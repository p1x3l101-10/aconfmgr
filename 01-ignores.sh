# Unique
IgnorePath '/etc/machine-id'
IgnorePath '/etc/machine-info'

# Managed externally
IgnorePath '/etc/dconf'
IgnorePath '/etc/localtime'
IgnorePath '/etc/cups'
IgnorePath '/etc/cups/printers.conf'
IgnorePath '/etc/cups/subscriptions.conf'
IgnorePath '/etc/cups/classes.conf'

# Generated automatically
IGNORE_CFG=(
	os-release
	vconsole.conf
	pkglist.txt
	resolv.conf
	locale.conf
	printcap
	shells
	fstab
	ssl
	colord
	fonts/conf.d
	ld.so.cache
	ca-certificates
	pacman.d/{mirrorlist,gnupg}
	'hostname'
	'.updated'
	'.pwd.lock'
)
for cfg in ${IGNORE_CFG[@]}; do
	IgnorePath "/etc/$cfg"
done
IgnorePath '/usr/lib'
IgnorePath '/usr/share'
IgnorePath '/var/.updated'
IgnorePath '/usr/lib32/gconv/gconv-modules.cache'
IgnorePath '/usr/share/gnome-shell/gnome-shell-theme.gresource'
IgnorePath '/efi'
IgnorePath '/var/tmp'
IgnorePath '/var/log'
IgnorePath '/boot'
IgnorePath '/var/spool'
IgnorePath '/var/db'
IgnorePath '/usr/local/share/themes/default-pure/gnome-shell'

# Secret
for passwd in group{,-} {g,}shadow{,-} passwd{,-} sub{gid,uid}{,-} samba/systemd ssh; do
	IgnorePath "/etc/$passwd"
done

# SO MUCH DATA
IgnorePath '/var/lib'
