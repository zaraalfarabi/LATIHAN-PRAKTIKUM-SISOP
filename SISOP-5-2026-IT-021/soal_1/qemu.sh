#!/bin/bash

case "$1" in
    --single)
        echo "Menjalankan OS: Mode Single-User..."
        qemu-system-x86_64 -kernel osboot/bzImage -initrd osboot/single.gz -append "console=ttyS0" -nographic -nic user,model=e1000
        ;;
    --multi)
        echo "Menjalankan OS: Mode Multi-User..."
        qemu-system-x86_64 -kernel osboot/bzImage -initrd osboot/multi.gz -append "console=ttyS0" -nographic
        ;;
    --all)
        echo "Menjalankan OS: Mode ISO (GRUB Menu)..."
        qemu-system-x86_64 -cdrom osboot/farewell.iso -m 512M
        ;;
    *)
        echo "Cara pakai yang benar:"
        echo "./qemu.sh --single   -> Boot langsung ke single-user"
        echo "./qemu.sh --multi    -> Boot langsung ke multi-user"
        echo "./qemu.sh --all      -> Boot ISO (pilih menu)"
        ;;
esac
