cat > "$(CreateFile /etc/pacman.conf)" << EOF
[options]
HoldPkg = pacman glibc
Architecture = auto
Color
CheckSpace
ParallelDownloads = 5
DownloadUser = alpm
SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional

# Offline updates rules
Include = /etc/pacman.d/offline.conf

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist

EOF

# Kernel cmdline
CreateFile '/etc/kernel/cmdline' > /dev/null
case "$HOSTNAME" in
	'pixels-pc') aug set '/files/etc/kernel/cmdline/root' "UUID=5c786018-e988-453c-944b-08f283e2bbb1";;
esac
aug set '/files/etc/kernel/cmdline/rw'
aug set '/files/etc/kernel/cmdline/loglevel' 4

cat > "$(CreateFile /etc/mkinitcpio.d/linux-zen.preset)" << EOF
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux-zen"
PRESETS=('default' 'fallback')
default_uki="/boot/archlinux-zen.efi"
fallback_uki="/boot/archlinux-zen-fallback.efi"
fallback_options="-z cat -S autodetect"
EOF

cat > "$(CreateFile /etc/doas.conf 400)" <<EOF
permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel
permit nopass :wheel as root cmd /usr/bin/aconfmgr
EOF

cat > "$(CreateFile /etc/mkinitcpio.conf)" << EOF
BINARIES=(btrfs)
HOOKS=(systemd autodetect plymouth microcode modconf kms keyboard keymap sd-vconsole block filesystems)
COMPRESSION="xz"
COMPRESSION_OPTIONS=("-9e")
MODULES_DECOMPRESS="no"
EOF

file="$(GetPackageOriginalFile glibc /etc/locale.gen)"
for locale in {en_us,ja_JP}.UTF-8; do
	sed -i "s/^#\($locale\)/\1/g" "$file"
done