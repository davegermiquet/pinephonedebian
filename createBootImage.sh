#!/bin/bash
export kernelVersion=$(make kernelversion|tr '\n' ' '|sed 's/^[ \t]*//;s/[ \t]*$//')
chroot /media/root /usr/bin/dracut --force  --local --fwdir=/lib/firmware /boot/initrd.img ${kernelVersion}
mkimage -A arm64 -O linux -T ramdisk -C gzip -n "Build Root File System" -d /media/root/boot/initrd.img /media/root/boot/initrd.img.uboot
mkimage -C none -A arm64 -T script -d /build/boot.cmd /media/root/boot/boot.scr
ls -la /media/root/boot
