#!/bin/bash
# Setting up serial
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
echo "T0:23:respawn:/sbin/getty -L ttyS0 115200 vt100" > /media/root/etc/inittab

mount devpts /media/root/dev/pts -t devpts

cp /usr/bin/qemu-aarch64-static /media/root/usr/bin/
chroot /media/root sh -c "cd /dev; mknod -m 666 ttyS0 c 4 64"
cp /etc/hosts /media/root/etc/

# Our proxy is apt-cacher-ng, which can't handle SSL connections
unset http_proxy

# Allow non-free components
echo "deb http://deb.debian.org/debian unstable main contrib non-free"  > /media/root/etc/apt/sources.list

chroot /media/root /usr/bin/apt-get -y update
chroot /media/root /usr/bin/apt-get -y install ca-certificates

# Install optional packages

chroot /media/root /usr/bin/apt-get -y update
chroot /media/root  /usr/bin/apt-get install -y apt-utils
chroot /media/root /usr/bin/apt-get install  -y --no-install-recommends gnupg2
chroot /media/root /usr/bin/apt-get -y upgrade
chroot /media/root /usr/bin/apt-get install -y libpam-cap
chroot /media/root /usr/bin/apt-get install -y --no-install-recommends alsa-ucm-conf \
  alsa-utils \
  busybox \
  ca-certificates \
  chrony \
  device-tree-compiler \
  dosfstools \
  f2fs-tools \
  file \
  hwdata \
   jitterentropy-rngd \
   kbd \
   locales \
   locales-all \
   man-db \
   mmc-utils \
   patch \
   python3-dbus \
   rtkit \
   usb-modeswitch \
   usbutils \
   u-boot-tools \
   libcanberra-pulse \
   libnss-myhostname \
   libnss-systemd \
   bash-completion \
   bzip2 \
   dialog \
   gawk \
   inxi \
   less \
   nano \
   psmisc \
   psutils \
   sudo \
   wget \
   unzip \
   xz-utils \
   bluetooth \
   crda \
   dnsmasq-base \
   inetutils-ping \
   iptables \
   iw \
   network-manager \
   pulseaudio-module-bluetooth \
   net-tools \
   rfkill \
   wireless-tools \
   wpasupplicant  \
   openssh-client \
   at-spi2-core \
   flatpak \
   gvfs-backends \
   iio-sensor-proxy \
   wayland-protocols  \
   evince file-roller fwupd geary lollypop nemo nemo-fileroller  qtwayland5   youtube-dl  ffmpeg \
  rygel \
        webext-ublock-origin  dracut  plymouth  plymouth-themes \
      sudo vim  dracut-core modemmanager libwayland-cursor++0 xcursor-themes \
      libwayland-client0 dbus libpam-systemd libwayland-cursor0  libpam-modules libpam-systemd libselinux1 libsystemd0 \
      bison build-essential cmake flex gettext git intltool libio-socket-ssl-perl \
      libjson-xs-perl liburi-perl  libyaml-libyaml-perl shared-mime-info

BOOTUID=$(blkid -s UUID -o value /build/recovery-pinephone-loop0p1 | tr '\n' ' ')
ROOTUID=$(blkid -s UUID -o value /build/recovery-pinephone-loop0p2 | tr '\n' ' ')

echo "UUID=${ROOTUID}     /       f2fs   defaults       0       0" > /media/root/etc/fstab
echo "UUID=${BOOTUID}     /boot   ext2   defaults      0       0" >> /media/root/etc/fstab

# Setup hostname
echo debian > /media/root/etc/hostname

# Generate locales (only en_US.UTF-8 for now)
chroot /media/root echo "LANG=en_US.UTF-8" > /etc/default/locale.gen
chroot /media/root echo "LANG=en_US.UTF-8" > /etc/default/locale
chroot /media/root local-gen

chroot /media/root /usr/bin/plymouth-set-default-theme solar

rm -rf  /media/root/lib/firmware
rsync -avh /build/firmware /media/root/lib
export USERNAME=debian
export PASSWORD=1234
chroot /media/root mkdir /var/lib/sddm
chroot /media/root adduser --gecos --home /var/lib/sddm --disabled-password --shell /bin/bash sddn --uid 2000
chroot /media/root adduser sddm video
chroot /media/root adduser --gecos $USERNAME --disabled-password --shell /bin/bash $USERNAME --uid 1000

# Needed for hardware access rights
chroot /media/root adduser $USERNAME video
chroot /media/root adduser $USERNAME render
chroot /media/root adduser $USERNAME audio
chroot /media/root adduser $USERNAME bluetooth
chroot /media/root adduser $USERNAME plugdev
chroot /media/root adduser $USERNAME dialout

chroot /media/root sh -c 'echo "$USERNAME:$PASSWORD" | chpasswd'
chroot /media/root sh -c 'echo "root:root" | chpasswd'

# Remove apt packages which are no longer unnecessary and delete
# downloaded packages
chroot /media/root update-locale
chroot /media/root apt -y autoremove --purge
chroot /media/root apt clean

# Remove SSH keys and machine ID so they get generated on first boot
chroot /media/root rm -f /etc/ssh/ssh_host_* \
      /etc/machine-id

mkdir /media/root/etc/sddm.conf.d/
echo << EOF >> /etc/sddm.conf.d/virtualkbd.conf
[General]
InputMethod=qtvirtualkeyboard
EOF

echo << EOF >> /etc/sddm.conf.d/avatar.conf
[Theme]
EnableAvatars=false
EOF



# Disable getty on tty1, as we won't connect in console mode anyway
chroot /media/root systemctl disable getty@.service
chroot /media/root systemctl enable sddm

# FIXME: these are automatically installed on first boot, and block
# the system startup for over 1 minute! Find out why this happens and
# avoid this nasty hack
chroot /media/root rm -f /lib/systemd/system/wpa_supplicant@.service \
      /lib/systemd/system/wpa_supplicant-wired@.service \
      /lib/systemd/system/wpa_supplicant-nl80211@.service
cd /


