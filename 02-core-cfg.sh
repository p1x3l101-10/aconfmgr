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
aug set '/files/etc/kernel/cmdline/init' /usr/lib/systemd/systemd

cat > "$(CreateFile /etc/doas.conf 400)" <<EOF
permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel
permit nopass :wheel as root cmd /usr/bin/aconfmgr
EOF

file="$(GetPackageOriginalFile glibc /etc/locale.gen)"
for locale in {en_us,ja_JP}.UTF-8; do
	sed -i "s/^#\($locale\)/\1/g" "$file"
done
