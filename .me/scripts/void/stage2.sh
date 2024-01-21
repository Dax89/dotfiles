#!/bin/sh

error() {
    echo "ERROR: $1"
    exit 1
}

check_service() {
    [ ! -d /var/service/"$1" ] && ln -s /etc/sv/"$1" /var/service
}

delete_if() {
    [ -f "$1" ] && rm "$1"
}

user="$1"

if [ -n "$user" ]; then
    useradd -m "$user"
    usermod -a -G wheel "$user"
    # usermod -a -G audio "$user"
    # usermod -a -G video "$user"
else
    error "User not specified"
fi

# Install packages
xbps-install -Sy xtools xorg-minimal xinit jq socklog-void \
 polkit elogind mesa lm_sensors pipewire wireplumber git \
 picom i3 polybar rofi kitty kitty-terminfo redshift geoclue2 \
 noto-fonts-ttf noto-fonts-ttf-extra noto-fonts-cjk noto-fonts-emoji \
 nerd-fonts-symbols-ttf blueman udiskie || exit 1

# Enable services
## Logging
check_service socklog-unix
check_service nanoklogd
## UDev & DBus
check_service udevd
check_service dbus
## User Session
check_service polkitd
check_service elogind

# Configure Pipewire
mkdir -p /etc/pipewire/pipewire.conf.d
ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

cd /home/"$user" || error "Home for user '$user' does not exists"

# Part of dotfiles
delete_if .bashrc
delete_if .bash_profile
delete_if .inputrc

curl -LO https://raw.githubusercontent.com/Dax89/dotfiles/master/.me/scripts/init_dotfiles.sh
chown "$user":"$user" ./init_dotfiles.sh

su "$user" << EOF
. ./init_dotfiles.sh
EOF