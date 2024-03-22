#!/bin/sh

ARCH="x86_64"
REPO="https://repo-default.voidlinux.org/current"
DISK="$1"

uefi=0
[ -d /sys/firmware/efi/efivars ] && uefi=1

if [ $uefi -eq 0 ]; then
    echo "NON UEFI system detected"
else
    echo "UEFI system detected"
fi

if [ -z "$DISK" ]; then
    echo "Invalid disk"
    exit 2
fi

# Install basic requirements
xbps-install -u xbps
xbps-install wget

mkfs.ext4 "$DISK"2
mount "$DISK"2 /mnt/

if [ $uefi = 1 ]; then
    mkfs.vfat "$DISK"1
    mkdir -p /mnt/boot/efi/
    mount "$DISK"1 /mnt/boot/efi/
fi

mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

XBPS_ARCH=$ARCH xbps-install -Sy -r /mnt -R "$REPO" \
    base-minimal linux dracut bash sudo dhcpcd openssh iwd neovim ncurses curl

xchroot /mnt /bin/bash << EOF
chsh -s /bin/bash root
echo "void" > /etc/hostname
echo "hostonly=yes" > /etc/dracut.conf.d/hostonly.conf
echo "KEYMAP=us" >> /etc/rc.local
ln -s /usr/share/zoneinfo/Europe/Rome /etc/localtime
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/default/libc-locales
sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^#\s//g' /etc/sudoers
xbps-reconfigure -f glibc-locales
cp /proc/mounts /etc/fstab
blkid >> /etc/fstab
ln -s /etc/sv/... /etc/runit/runsvdir/default
ln -s /etc/sv/dhcpcd /etc/runit/runsvdir/default
ln -s /etc/sv/iwd /etc/runit/runsvdir/default
ln -s /etc/sv/sshd /etc/runit/runsvdir/default
EOF

if [ "$uefi" = 1 ]; then
    XBPS_ARCH=$ARCH xbps-install -Sy -r /mnt -R "$REPO" grub-$ARCH-efi 

    xchroot /mnt /bin/bash << EOT
grub-install --target=$ARCH-efi --efi-directory=/boot/efi --bootloader-id="Void"
xbps-reconfigure -fa
EOT
    umount -R /mnt/boot/efi
else
    XBPS_ARCH=$ARCH xbps-install -Sy -r /mnt -R "$REPO" grub

    xchroot /mnt /bin/bash << EOT
grub-install "$DISK"
xbps-reconfigure -fa
EOT
fi

echo "********* BEFORE REBOOT *********"
echo "Change root password with 'passwd'"
echo "Modify /etc/fstab"
echo "********* BEFORE REBOOT *********"

if [ -f stage2.sh ]; then
    mv ./stage2.sh /mnt/root
    mv ./get_dotfiles.sh /mnt/root
    mv ./setup_xbps.sh.sh /mnt/root
    chmod +x /mnt/root/stage2.sh
fi

xchroot /mnt /bin/bash

