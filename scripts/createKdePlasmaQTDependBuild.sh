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
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev  flex bison gperf libicu-dev libxslt-dev ruby libjpeg-dev libgstreamermm-1.0-dev libjsoncpp-dev libwebp-dev 	
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev libnvidia-egl-wayland-dev libkf5wayland-dev libkwaylandserver-dev libwayland-dev libwayland-egl-backend-dev libweston-9-dev  libdrm-dev libavcodec-dev ninja-build
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libxcb-glx0-dev libxcb-keysyms1-dev  libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxkbcommon-dev libxkbcommon-x11-dev  python qtbase5-dev libsqlite3-dev ruby2.7-dev  ruby-sqlite3 
chroot /media/fakeinstallroot /usr/bin/apt-get -y install  libxcb-xinerama0-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev gperf bison nodejs
chroot /media/fakeinstallroot /usr/bin/apt-get -y install bison build-essential gperf flex ruby python libasound2-dev libbz2-dev libcap-dev  libdrm-dev libegl1-mesa-dev libgcrypt-dev libnss3-dev libpci-dev libpulse-dev libudev-dev  libxtst-dev gyp ninja-build libcups2-dev libxtst-dev 
chroot /media/fakeinstallroot /usr/bin/apt-get -y install libwayland-dev libwayland-egl1-mesa libwayland-server0 libgles2-mesa-dev libxkbcommon-dev ccache
chroot /media/fakeinstallroot /usr/bin/apt-get -y install build-essential libfontconfig1-dev libdbus-1-dev libfreetype6-dev libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libssl-dev libpng-dev libjpeg-dev libglib2.0-dev  libclang-11-dev libclang-common-11-dev libatspi2.0-dev 
chroot /media/fakeinstallroot /usr/bin/apt-get -y upgrade