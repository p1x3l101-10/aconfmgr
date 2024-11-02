CreateFile /etc/samba/smb.conf > /dev/null
CreateDir /etc/gnome-remote-desktop '' gnome-remote-desktop gnome-remote-desktop

cat >> "$(GetPackageOriginalFile systemd /etc/systemd/system.conf)" <<EOF
DefaultTimeoutStopSec=15s
EOF

echo "kernel.sysrq = 1" > "$(CreateFile /etc/sysctl.d/99-sysrq.conf)"

f="$(GetPackageOriginalFile filesystem /etc/nsswitch.conf)"
sed -i '/^hosts:/ s/$/ mdns_minimal [NOTFOUND=return]/' "$f" # Appends to hosts list

SetFileProperty /etc/samba/smb.conf mode 700
SetFileProperty /etc/samba mode 700