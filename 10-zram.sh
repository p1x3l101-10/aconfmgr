cat > "$(CreateFile /etc/systemd/zram-generator.conf.d/zram0.conf)" << EOF
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF