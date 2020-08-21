DEBOS_CMD=docker
$DEBOS_CMD exec mobianinstaller umount /media/boot/
$DEBOS_CMD exec mobianinstaller umount /media/root/
$DEBOS_CMD exec mobianinstaller /tmp/unlinknode.sh
$DEBOS_CMD exec mobianinstaller losetup -D
$DEBOS_CMD exec mobianinstaller unlink /tmp/recovery-pinephone-loop0
$DEBOS_CMD exec mobianinstaller rm /tmp/mobian.img
$DEBOS_CMD stop mobianinstaller
