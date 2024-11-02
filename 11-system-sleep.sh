cat > "$(CreateFile /etc/systemd/sleep.conf.d/light-suspend.conf)" << EOF
[Sleep]
MemorySleepMode=s2idle
EOF