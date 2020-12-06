#!/bin/bash
mount proc /media/fakeinstallroot/proc -t proc
# install virtual environment
cp /usr/bin/qemu-aarch64-static /media/fakeinstallroot/usr/bin/

# install repository and dependencies
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
echo "deb http://deb.debian.org/debian unstable main contrib non-free"  > /media/fakeinstallroot/etc/apt/sources.list
chroot /media/fakeinstallroot /usr/bin/apt-get -y update
chroot /media/fakeinstallroot /usr/bin/apt-get -y install ca-certificates
chroot /media/fakeinstallroot /usr/bin/apt-get -y install build-essential cmake  libxml-parser-perl libwww-perl perl
chroot /media/fakeinstallroot /usr/bin/apt-get -y install flex bison gperf libicu-dev libxslt-dev ruby  libical-dev distcc ccache libxcb-composite0-dev xcb  libxcb-icccm4-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev  flex bison gperf libicu-dev libxslt-dev ruby
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libxcb-glx0-dev libxcb-keysyms1-dev  libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxkbcommon-dev libxkbcommon-x11-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install  build-dep qt5-default  libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev python kde-workspace qtbase5-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install  libxcb-xinerama0-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev gperf bison nodejs
chroot /media/fakeinstallroot /usr/bin/apt-get -y upgrade