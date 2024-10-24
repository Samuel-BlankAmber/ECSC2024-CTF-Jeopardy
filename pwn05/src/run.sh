#!/bin/sh

EXPLOIT=$1
if [ ! -f "$EXPLOIT" ]; then
    touch $EXPLOIT
fi

qemu-system-x86_64 \
    -kernel /home/user/bzImage \
    -cpu qemu64,+smep,+smap,+rdrand \
    -smp 1 \
    -m 1G \
    -hda /home/user/tmp/flag.img \
    -hdb $EXPLOIT \
    -initrd /home/user/initramfs.cpio.gz \
    -append "console=ttyS0 quiet loglevel=3 oops=panic panic_on_warn=1 panic=-1 pti=on page_alloc.shuffle=1" \
    -monitor /dev/null \
    -nographic \
    -object rng-random,filename=/dev/urandom,id=rng0 \
    -device virtio-rng-pci,rng=rng0 \
    -no-reboot
