CreateLink /etc/systemd/system/getty.target.wants/getty@tty1.service /usr/lib/systemd/system/getty@.service

for unit in {sshd,winbind,NetworkManager,systemd-homed,systemd-networkd,smb}.service remote-fs.target; do
    EnableUnit multi-user.target $unit
done
for unit in {cups,systemd-userdbd,systemd-networkd}.socket; do
    EnableUnit sockets.target $unit
done
for unit in {systemd-boot-update,systemd-network-generator,systemd-resolved}.service; do
    EnableUnit sysinit.target $unit
done
for unit in {NetworkManager-wait-online,systemd-networkd-wait-online}.service; do
    EnableUnit network-online.target $unit
done

EnableUnit systemd-homed.service systemd-homed-activate.service
EnableUnit timers.target pacman-offline-prepare.timer
EnableUnit bluetooth.{target,service}

AliasUnit {display-manager,gdm}.service 
AliasUnit dbus-org.bluez.service bluetooth.service
AliasUnit dbus-org.freedesktop.nm-dispatcher.service NetworkManager-dispatcher.service
AliasUnit dbus-org.freedesktop.home1.service systemd-homed.service
AliasUnit dbus-org.freedesktop.network1.service systemd-networkd.service
AliasUnit dbus-org.freedesktop.resolve1.service systemd-resolved.service

# User things
for unit in {gnome-keyring-daemon,p11-kit-server,pipewire-pulse,pipewire}.socket; do
    EnableUnit sockets.target $unit user
done

EnableUnit default.target xdg-user-dirs-update.service user
EnableUnit pipewire.service wireplumber.service user

AliasUnit pipewire-session-manager.service wireplumber.service user