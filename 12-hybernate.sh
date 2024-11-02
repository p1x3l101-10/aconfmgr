case "$HOSTNAME" in
	'pixels-pc') aug set '/files/etc/kernel/cmdline/resume' 'UUID=8546358e-1664-451c-8356-199cc38843b0';;
esac

RemoveFile '/etc/systemd/sleep.conf.d/light-suspend.conf'
cat > "$(CreateFile /etc/systemd/sleep.conf.d/hybrid-sleep.conf)" << EOF
[Sleep]
MemorySleepMode=deep
EOF

CopyFile '/etc/systemd/system/suspend-sedation.service'
CreateLink /etc/systemd/system/{sleep.target.wants,}suspend-sedation.service