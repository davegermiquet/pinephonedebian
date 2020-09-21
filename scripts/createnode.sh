#!/bin/bash
export LOOPDEV=/build/recovery-pinephone-loop0
export NODE=101

# drop the first line, as this is our LOOPDEV itself, but we only want the child partitions
PARTITIONS=$(lsblk --raw | grep $NODE | grep part | cut -d\  -f 2)
echo $PARTITIONS
COUNTER=1
for i in $PARTITIONS; do
    MAJ=$(echo $i | cut -d: -f1)
    MIN=$(echo $i | cut -d: -f2)
#    MIN=$((RAWMIN+1))
    if [ ! -e "${LOOPDEV}p${COUNTER}" ]; then mknod ${LOOPDEV}p${COUNTER} b $MAJ $MIN; fi
    COUNTER=$((COUNTER + 1))
done
