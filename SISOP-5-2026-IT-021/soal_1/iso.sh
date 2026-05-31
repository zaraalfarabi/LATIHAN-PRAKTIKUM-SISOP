#!/bin/bash
set -e

echo "1. Menyiapkan folder untuk kerangka ISO..."
mkdir -p isodir/boot/grub

echo "2. Memasukkan Kernel dan Filesystem ke dalam ISO..."
cp osboot/bzImage isodir/boot/
cp osboot/single.gz isodir/boot/
cp osboot/multi.gz isodir/boot/

echo "3. Membuat menu GRUB (Menu pas OS baru nyala)..."
cat << 'EOF' > isodir/boot/grub/grub.cfg
set timeout=5
set default=0

menuentry "Farewell Party - Single User Mode" {
    linux /boot/bzImage console=ttyS0 console=tty0
    initrd /boot/single.gz
}

menuentry "Farewell Party - Multi User Mode" {
    linux /boot/bzImage console=ttyS0 console=tty0
    initrd /boot/multi.gz
}
EOF

echo "4. Membungkus menjadi farewell.iso..."

grub-mkrescue -o osboot/farewell.iso isodir

echo "5. Membersihkan folder sisa..."
rm -rf isodir

echo "YEY! File farewell.iso BERHASIL DIBUAT di folder osboot/!"
