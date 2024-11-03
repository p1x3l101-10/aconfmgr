# Kernel cmdline
CreateFile '/etc/kernel/cmdline' > /dev/null
case "$HOSTNAME" in
	'pixels-pc') aug set '/files/etc/kernel/cmdline/root' "UUID=5c786018-e988-453c-944b-08f283e2bbb1";;
	'pixels-laptop') aug set '/files/etc/kernel/cmdline/root' "UUID=988fdaaf-b0a9-43cb-816b-a5c4ed89efcb";;
esac
aug set '/files/etc/kernel/cmdline/rw'
aug set '/files/etc/kernel/cmdline/loglevel' 4
aug set '/files/etc/kernel/cmdline/init' /usr/lib/systemd/systemd

cat > "$(CreateFile /etc/kernel/install.conf)" << EOF
layout=uki
initrd_generator=mkinitcpio
uki_generator=ukify
EOF

cat > "$(CreateFile /etc/systemd/ukify.conf)" << EOF
[UKI]
Cmdline=@/etc/kernel/cmdline
Splash=/usr/share/systemd/bootctl/splash-arch.bmp
SecureBootSigningTool=sbsign
SecureBootPrivateKey=/var/lib/sbctl/keys/db/db.key
SecureBootCertificate=/var/lib/sbctl/keys/db/db.pem
EOF
# Ensure mkinitcpio
AddPackage mkinitcpio

# Mask mkinitcpio hooks
CreateLink /etc/pacman.d/hooks/60-mkinitcpio-remove.hook /dev/null
CreateLink /etc/pacman.d/hooks/90-mkinitcpio-install.hook /dev/null

# Add hooks for kernel-install
cat > "$(CreateFile /etc/pacman.d/scripts/kernel-install)" << EOF
#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit nullglob

cd /

all_kernels=0
declare -A versions

add_file() {
	local kver="\$1"
	kver="\${kver##usr/lib/modules/}"
	kver="\${kver%%/*}"
	versions["\$kver"]=""
}

while read -r path; do
	case "\$path" in
	usr/lib/modules/*/vmlinuz | usr/lib/modules/*/extramodules/*)
		add_file "\$path"
		;;
	*)
		all_kernels=1
		;;
	esac
done

((all_kernels)) && for file in usr/lib/modules/*/vmlinuz; do
	pacman -Qqo "\$file" 1>/dev/null 2>/dev/null &&
		add_file "\$file"
done

for kver in "\${!versions[@]}"; do
	kimage="/usr/lib/modules/\$kver/vmlinuz"
	echo >&2 +kernel-install "\$@" "\$kver" "\$kimage"
	kernel-install "\$@" "\$kver" "\$kimage" || true
done
EOF
SetFileProperty /etc/pacman.d/scripts/kernel-install mode 755
cat > "$(CreateFile /etc/pacman.d/hooks/40-kernel-install-remove.hook)" << EOF
[Trigger]
Type = Path
Operation = Upgrade
Operation = Remove
Target = usr/lib/modules/*/vmlinuz
Target = usr/lib/modules/*/extramodules/*

[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Operation = Remove
Target = boot/*-ucode.img
Target = usr/lib/booster/*
Target = usr/lib/initcpio/*
Target = usr/lib/initcpio/*/*
Target = usr/lib/dracut/*
Target = usr/lib/dracut/*/*
Target = usr/lib/dracut/*/*/*
Target = usr/lib/kernel/*
Target = usr/lib/kernel/*/*
Target = usr/src/*/dkms.conf

[Action]
Description = Removing kernel and initrd from \$BOOT... (kernel-install)
When = PostTransaction
Exec = /etc/pacman.d/scripts/kernel-install remove
NeedsTargets
EOF
cat > "$(CreateFile /etc/pacman.d/hooks/90-kernel-install-add.hook)" << EOF
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = usr/lib/modules/*/vmlinuz
Target = usr/lib/modules/*/extramodules/*

[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Operation = Remove
Target = boot/*-ucode.img
Target = usr/lib/booster/*
Target = usr/lib/initcpio/*
Target = usr/lib/initcpio/*/*
Target = usr/lib/dracut/*
Target = usr/lib/dracut/*/*
Target = usr/lib/dracut/*/*/*
Target = usr/lib/kernel/*
Target = usr/lib/kernel/*/*
Target = usr/src/*/dkms.conf

[Action]
Description = Installing kernel and initrd to \$BOOT... (kernel-install)
When = PostTransaction
Exec = /etc/pacman.d/scripts/kernel-install add
NeedsTargets
EOF

cat > "$(CreateFile /etc/pacman.d/hooks/80-secureboot.hook)" <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Type = Path
Target = usr/lib/systemd/boot/efi/systemd-boot*.efi

[Action]
Description = Signing systemd-boot EFI binary for Secure Boot
When = PostTransaction
Exec = /bin/sh -c 'while read -r i; do sbsign --key /var/lib/sbctl/keys/db/db.key --cert /var/lib/sbctl/keys/db/db.pem "\$i"; done;'
Depends = sh
Depends = sbsigntools
NeedsTargets
EOF
IgnorePath '/usr/lib/systemd/boot/efi/systemd-boot*.efi' # Prevent unsigning

cat > "$(CreateFile /etc/mkinitcpio.conf)" << EOF
BINARIES=(btrfs)
HOOKS=(systemd autodetect plymouth microcode modconf kms keyboard keymap sd-vconsole block filesystems)
COMPRESSION="xz"
COMPRESSION_OPTIONS=("-9e")
MODULES_DECOMPRESS="no"
EOF

