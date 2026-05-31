#!/bin/bash

echo "=== MEMULAI PROSES BACKUP ==="

# Masuk ke folder osboot
cd osboot/ || exit 1

echo "1. Membuat file zip dari file utama..."
# Menggunakan tar sebagai alternatif jika perintah zip bermasalah di WSL
tar -cvzf farewell_backup_$(date +"%d%m%Y-%H%M%S").tar.gz bzImage single.gz multi.gz farewell.iso

if [ $? -eq 0 ]; then
    echo "2. Kompresi BERHASIL! Menghubungkan dan menghapus file asli..."
    rm -f bzImage single.gz multi.gz farewell.iso
    echo "=== BACKUP SELESAI DENGAN SUKSES ==="
else
    echo "ERROR: Proses kompresi gagal!"
fi

cd ..
