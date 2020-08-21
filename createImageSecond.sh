#!/bin/bash
# Setting up serial
echo "T0:23:respawn:/sbin/getty -L ttyS0 115200 vt100" > /arm64fs_debian/etc/inittab
mount proc /media/root/proc -t proc
mount devpts /media/root/dev/pts -t devpts

cp /usr/bin/qemu-aarch64-static /media/root/usr/bin/
chroot /arm64fs_debian sh -c "cd /dev; mknod -m 666 ttyS0 c 4 64"
cp /etc/hosts /arm64fs_debian/etc/

# Our proxy is apt-cacher-ng, which can't handle SSL connections
unset http_proxy

# Allow non-free components
echo "deb http://deb.debian.org/debian testing main contrib non-free"  > /arm64fs_debian/etc/apt/sources.list
echo "deb https://repo.mobian-project.org mobian main non-free" >> /arm64fs_debian/etc/apt/sources.list
echo APT::Default-Release \"testing\"\; > /arm64fs_debian/etc/apt/apt.conf.d/99defaultrelease

wget -O - https://repo.mobian-project.org/mobian.gpg.key > /arm64fs_debian/tmp/mobian.gpg.key
chroot /arm64fs_debian apt-key add /tmp/mobian.gpg.key

# Install optional packages

chroot /arm64fs_debian  sh -c "/usr/bin/apt-get update"
chroot /arm64fs_debian  sh -c "/usr/bin/apt-get install apt-utils"
chroot /arm64fs_debian  sh -c "/usr/bin/apt-get -y install ca-certificates"
chroot /arm64fs_debian sh -c "/usr/bin/apt-get install  -y --no-install-recommends gnupg2"
chroot /arm64fs_debian /usr/bin/apt-get -y upgrade
chroot /arm64fs_debian /usr/bin/apt-get install -y libpam-cap
chroot /arm64fs_debian /usr/bin/apt-get install -y --no-install-recommends alsa-ucm-conf \
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
   fonts-cantarell \
   fonts-noto \
   fonts-noto-cjk \
   fonts-noto-color-emoji \
   fonts-noto-mono \
   fonts-noto-ui-core \
   mesa-va-drivers \
   mesa-vdpau-drivers \
   wayland-protocols \
   xdg-desktop-portal-gtk \
   xdg-user-dirs \
   libcanberra-gtk3-module libpam-gnome-keyring feedbackd \
   gnome-bluetooth gnome-control-center gnome-online-accounts \
   gnome-session \
   gnome-settings-daemon gnome-themes-extra-data  network-manager-gnome phoc squeekboard \
    calls chatty purple-mm-sms wys gnome-2048 gnome-chess sgt-solo \
   evince file-roller fwupd geary gedit gthd gnome-calculator gnome-calendar \
   gnome-contacts gnome-clocks gnome-initial-setup gnome-maps gnome-software \
   gnome-software-plugin-flatpak gnome-usage kgx  lollypop nemo nemo-fileroller \
   pinhole  purple-lurch  purple-xmpp-http-upload qtwayland5 telegram-purple  youtube-dl  ffmpeg \
   gstreamer1.0-gl gstreamer1.0-nice gstreamer1.0-packagekit  gstreamer1.0-pulseaudio rygel \
   gir1.2-secret-1 python3-bs4  python3-gi python3-pil python3-pyfavicon python3-pyotp \
   python3-pyzbar   python3-yoyo-migrations  dconf-gsettings-backend dconf-gsettings-backend \
    gconf-gsettings-backend gir1.2-handy-0.0 python3-gi  gconf-gsettings-backend phosh eog \
      epiphany-browser   firefox-esr  gnome-sound-recorder  gnome-todo  pinhole \
        telegram-desktop   webext-ublock-origin  dracut    plymouth  plymouth-themes \
      sudo vim  dracut-core modemmanager




BOOTUID=$(blkid -s UUID -o value /build/recovery-pinephone-loop0p1 | tr '\n' ' ')
ROOTUID=$(blkid -s UUID -o value /build/recovery-pinephone-loop0p2 | tr '\n' ' ')

echo "UUID=${ROOTUID}     /       f2fs   defaults       0       0" > /arm64fs_debian/etc/fstab
echo "UUID=${BOOTUID}     /boot   ext2   defaults      0       0" >> /arm64fs_debian/etc/fstab

# Setup hostname
echo debian > /arm64fs_debian/etc/hostname

# Generate locales (only en_US.UTF-8 for now)
chroot /arm64fs_debian echo "LANG=en_US.UTF-8" > /etc/default/locale.gen
chroot /arm64fs_debian echo "LANG=en_US.UTF-8" > /etc/default/locale
chroot /arm64fs_debian local-gen

chroot /arm64fs_debian /usr/bin/plymouth-set-default-theme solar

# Load phosh on startup if package is installed
chroot /arm64fs_debian  /usr/bin/systemctl enable phosh.service

rm -rf  /arm64fs_debian/lib/firmware
rsync -avh /build/firmware /arm64fs_debian/lib
export USERNAME=debian
export PASSWORD=1234

chroot /arm64fs_debian adduser --gecos $USERNAME --disabled-password --shell /bin/bash $USERNAME --uid 1000

# Needed for hardware access rights
chroot /arm64fs_debian adduser $USERNAME video
chroot /arm64fs_debian adduser $USERNAME render
chroot /arm64fs_debian adduser $USERNAME audio
chroot /arm64fs_debian adduser $USERNAME bluetooth
chroot /arm64fs_debian adduser $USERNAME plugdev
chroot /arm64fs_debian adduser $USERNAME dialout

chroot /arm64fs_debian sh -c 'echo "$USERNAME:$PASSWORD" | chpasswd'
chroot /arm64fs_debian sh -c 'echo "root:root" | chpasswd'

# Remove apt packages which are no longer unnecessary and delete
# downloaded packages
chroot /arm64fs_debian update-locale
chroot /arm64fs_debian apt -y autoremove --purge
chroot /arm64fs_debian apt clean

# Remove SSH keys and machine ID so they get generated on first boot
chroot /arm64fs_debian rm -f /etc/ssh/ssh_host_* \
      /etc/machine-id

# Disable getty on tty1, as we won't connect in console mode anyway
chroot /arm64fs_debian systemctl disable getty@.service

# FIXME: these are automatically installed on first boot, and block
# the system startup for over 1 minute! Find out why this happens and
# avoid this nasty hack
chroot /arm64fs_debian rm -f /lib/systemd/system/wpa_supplicant@.service \
      /lib/systemd/system/wpa_supplicant-wired@.service \
      /lib/systemd/system/wpa_supplicant-nl80211@.service
cd /


