#!/bin/sh

export PATH=/sbin:/usr/sbin:$PATH
IMG_FILE="mobian-$device-`date +%Y%m%d`.img"
DEBOS_CMD=docker 
ARGS="run -d --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup --privileged=true --name mobianinstaller -dit amd64/debian /bin/bash"


# pull the buster image


$DEBOS_CMD pull amd64/debian

# create new docker of mobian installer or start it if existing


$DEBOS_CMD $ARGS || docker start mobianinstaller


# install necessary dependencies for compilation
$DEBOS_CMD exec mobianinstaller /usr/bin/apt-get -y update
$DEBOS_CMD exec mobianinstaller  dpkg --add-architecture arm64
$DEBOS_CMD exec mobianinstaller /usr/bin/apt-get -y --no-install-recommends install ansible f2fs-tools debootstrap git \
crossbuild-essential-arm64 parted flex bison python3-distutils \
 swig python3-dev u-boot-tools build-essential device-tree-compiler \
bison flex libssl-dev libncurses-dev bc qemu-utils qemu-efi-aarch64\
 qemu-system-aarch64 binfmt-support qemu qemu-user-static  python3-pip \
 cpio rsync dpkg-dev fakeroot e2fsprogs mount eject kmod \
 dracut dpkg-cross systemd-container
$DEBOS_CMD exec mobianinstaller apt-get install libc6:arm64

# copy over needed files

$DEBOS_CMD exec mobianinstaller mkdir /build
$DEBOS_CMD cp build.sh mobianinstaller:/build
$DEBOS_CMD cp createBootImage.sh mobianinstaller:/build
$DEBOS_CMD cp init.sh mobianinstaller:/build
$DEBOS_CMD cp unlinknode.sh mobianinstaller:/build
$DEBOS_CMD cp createImageSecond.sh mobianinstaller:/build
$DEBOS_CMD cp createnode.sh mobianinstaller:/build
$DEBOS_CMD cp backup.sh mobianinstaller:/build
$DEBOS_CMD cp boot.cmd mobianinstaller:/build
$DEBOS_CMD cp ansible-image.yml mobianinstaller:/build
$DEBOS_CMD exec mobianinstaller wget http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6_2.31-3_arm64.deb

# start running docker commands
$DEBOS_CMD exec mobianinstaller df -h

# run playbook
$DEBOS_CMD exec mobianinstaller /usr/bin/ansible-playbook -vvvvv /build/ansible-image.yml

# copy over artifacts for downloading
$DEBOS_CMD exec mobianinstaller umount /media/root/boot
$DEBOS_CMD exec mobianinstaller umount /media/root/proc
$DEBOS_CMD exec mobianinstaller umount /media/root/dev/pts
$DEBOS_CMD exec mobianinstaller umount /media/root/
$DEBOS_CMD exec mobianinstaller /build/unlinknode.sh

$DEBOS_CMD exec mobianinstaller losetup -D
$DEBOS_CMD exec mobianinstaller unlink /build/recovery-pinephone-loop0
$DEBOS_CMD cp mobianinstaller:/build/mobian.img mobian.img

# cleanup all the old unnecessary for next build

$DEBOS_CMD exec mobianinstaller rm /build/mobian.img
$DEBOS_CMD stop mobianinstaller
