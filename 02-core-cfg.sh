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

cat > "$(CreateFile /etc/doas.conf 400)" <<EOF
permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel
permit nopass :wheel as root cmd /usr/bin/aconfmgr
EOF

file="$(GetPackageOriginalFile glibc /etc/locale.gen)"
for locale in {en_us,ja_JP}.UTF-8; do
	sed -i "s/^#\($locale\)/\1/g" "$file"
done
