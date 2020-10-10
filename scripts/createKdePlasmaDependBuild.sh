#!/bin/bash
mount proc /media/fakeinstallroot/proc -t proc
# install virtual environment
cp /usr/bin/qemu-aarch64-static /media/fakeinstallroot/usr/bin/

# install repository and dependencies
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
echo "deb http://deb.debian.org/debian unstable main contrib non-free"  > /media/fakeinstallroot/etc/apt/sources.list
chroot /media/fakeinstallroot /usr/bin/apt-get -y update
chroot /media/fakeinstallroot /usr/bin/apt-get -y install ca-certificates
chroot /media/fakeinstallroot /usr/bin/apt-get -y install build-essential
chroot /media/fakeinstallroot /usr/bin/apt-get -y install flex bison gperf libicu-dev libxslt-dev ruby  libical-dev distcc ccache distcc-pump libxcb-composite0-dev xcb  libxcb-icccm4-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libxcb-glx0-dev libxcb-keysyms1-dev  libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxcd-xinerama-dev libxkbcommon-dev libxkbcommon-x11-dev libxext
chroot /media/fakeinstallroot /usr/bin/apt-get -y upgrade