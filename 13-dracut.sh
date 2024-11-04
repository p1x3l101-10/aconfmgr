# Replace mkinitcpio with dracut for booting
AddPackage dracut
RemovePackage mkinitcpio

sed -i 's/mkinitcpio/dracut/' "$INSTALLKERNEL_CONF"

dir='/etc/dracut.conf.d'
case $HOSTNAME in
	'pixels-pc') gfxDriver='amdgpu';;
	'pixels-laptop') gfxDriver='i915';;
esac

echo 'hostonly="yes"' > "$(CreateFile $dir/hostonly.conf)"
echo 'compress="xz"' > "$(CreateFile $dir/compress.conf)"
echo 'filesystems="btrfs"' > "$(CreateFile $dir/fs.conf)"
echo 'add_dracutmodules+=" plymouth "' > "$(CreateFile $dir/plymouth.conf)"
echo 'add_dracutmodules+=" resume "' > "$(CreateFile $dir/resume.conf)"
echo 'add_dracutmodules+="crypt"' > "$(CreateFile $dir/crypt.conf)"
echo 'add_dracutmodules+="btrfs"' > "$(CreateFile $dir/btrfs.conf)"
echo 'omit_dracutmodules+=" network "' > "$(CreateFile $dir/noNetwork.conf)"
echo "add_drivers+=\" $gfxDriver \"" > "$(CreateFile $dir/earlyKms.conf)"
