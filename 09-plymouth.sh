f='/files/etc/kernel/cmdline'
aug set "$f/splash"
aug set "$f/quiet"
aug set "$f/plymouth.use-simpledrm"
aug set "$f/plymouth.nolog"
aug set "$f/loglevel" 3 # Silence kernel when using plymouth
aug set "$f/systemd.show_status" auto
aug set "$f/rd.udev.log_level" 3

echo "kernel.printk = 3 3 3 3" > "$(CreateFile /etc/sysctl.d/20-quiet-printk.conf)"
