#!/bin/sh
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export PATH=/sbin:/usr/sbin:$PATH
IMG_FILE="debian-$device-`date +%Y%m%d`.img"
DEBOS_CMD=docker
ARGS="run -d --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup   --network=debiananddistcc  --privileged=true --name debianinstaller -dit amd64/debian /bin/bash"

  cd configFiles
  $DEBOS_CMD network create \
    --driver=bridge \
    --subnet=172.28.0.0/16 \
    --ip-range=172.28.0.0/16 \
    --gateway=172.28.5.254 \
    debiananddistcc
  $DEBOS_CMD rm distcc
  $DEBOS_CMD rmi distcc
  $DEBOS_CMD build -t distcc .
  cd ..
  $DEBOS_CMD run -d --network=debiananddistcc -p3636:3636 -p3632:3632 -p3633:3633 -eOPTIONS="--allow 0.0.0.0/0" --name distcc -dit distcc /bin/bash

# pull the buster image


$DEBOS_CMD pull amd64/debian

# create new docker of debian installer or start it if existing

# need better check laterg
sleep 30

$DEBOS_CMD $ARGS || docker start debianinstaller


# install necessary dependencies for compilation
$DEBOS_CMD exec debianinstaller /usr/bin/apt-get -y update
$DEBOS_CMD exec debianinstaller  dpkg --add-architecture arm64
$DEBOS_CMD exec debianinstaller /usr/bin/apt-get -y --no-install-recommends install ansible f2fs-tools debootstrap git \
 parted flex bison python3-distutils \
 swig python3-dev u-boot-tools device-tree-compiler \
bison flex libssl-dev libncurses-dev bc qemu-utils qemu-efi-aarch64\
 qemu-system-aarch64 binfmt-support qemu qemu-user-static  python3-pip \
 cpio rsync e2fsprogs mount eject kmod \
 dracut systemd-container snapd  git bzr dialog unzip

# copy over needed files

$DEBOS_CMD exec debianinstaller mkdir /build
$DEBOS_CMD cp scripts/ debianinstaller:/build/
$DEBOS_CMD cp configFiles/ debianinstaller:/build/
$DEBOS_CMD cp ansible-prepare-plasma.yml debianinstaller:/build/
$DEBOS_CMD cp ansible-download-plasma.yml debianinstaller:/build/
$DEBOS_CMD cp ansible-extract-plasma.yml debianinstaller:/build/

# start running docker commands
$DEBOS_CMD exec debianinstaller df -h

# run playbook
$DEBOS_CMD exec debianinstaller /usr/bin/ansible-playbook -vvvvv /build/ansible-prepare-plasma.yml
$DEBOS_CMD exec debianinstaller /usr/bin/ansible-playbook -vvvvv /build/ansible-download-plasma.yml
$DEBOS_CMD exec debianinstaller /usr/bin/ansible-playbook -vvvvv /build/ansible-extract-plasma.yml

# copy over artifacts for downloading
$DEBOS_CMD exec debianinstaller umount /media/root/boot
$DEBOS_CMD exec debianinstaller umount /media/root/proc
$DEBOS_CMD exec debianinstaller umount /media/root/dev/pts
$DEBOS_CMD exec debianinstaller umount /media/root/
$DEBOS_CMD exec debianinstaller /build/scripts/unlinknode.sh

$DEBOS_CMD exec debianinstaller losetup -D
  $DEBOS_CMD exec debianinstaller unlink /build/recovery-pinephone-loop0
$DEBOS_CMD cp debianinstaller:/build/scripts/debian.img debian.img

# cleanup all the old unnecessary for next build

$DEBOS_CMD exec debianinstaller rm /build/scripts/debian.img
$DEBOS_CMD stop debianinstaller
$DEBOS_CMD stop distcc
$DEBOS_CMD rm distcc