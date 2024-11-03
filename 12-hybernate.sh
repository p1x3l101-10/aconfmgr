case "$HOSTNAME" in
	'pixels-pc') aug set '/files/etc/kernel/cmdline/resume' 'UUID=8546358e-1664-451c-8356-199cc38843b0';;
	'pixels-laptop') aug set '/files/etc/kernel/cmdline/resume' 'UUID=0a678467-8876-4198-828a-93ae14378cdc';;
esac

RemoveFile '/etc/systemd/sleep.conf.d/light-suspend.conf'
cat > "$(CreateFile /etc/systemd/sleep.conf.d/hybrid-sleep.conf)" << EOF
[Sleep]
MemorySleepMode=deep
EOF
