#!/bin/bash
set -e

echo "1. Membersihkan sisa file yang gagal tadi..."
rm -rf linux-6.1.1
tar -xf linux-6.1.1.tar.xz
cd linux-6.1.1

echo "2. Membuat konfigurasi dasar..."
make defconfig

echo "3. Mematikan fitur rewel di WSL & Compiler (Sertifikat, BTF, Werror)..."
scripts/config --disable SYSTEM_TRUSTED_KEYS
scripts/config --disable SYSTEM_REVOCATION_KEYS
scripts/config --disable DEBUG_INFO_BTF
scripts/config --disable DEBUG_INFO_BTF_MODULES
scripts/config --disable WERROR

echo "4. Mengunci konfigurasi biar gak nanya-nanya lagi..."
make olddefconfig

echo "5. Mulai compile kernel (Tunggu ya, butuh waktu)..."
make -j2 bzImage

echo "6. Memindahkan file..."
cp arch/x86/boot/bzImage ../osboot/
cd ..

echo "YEY! KERNEL BERHASIL DICOMPILE!"
