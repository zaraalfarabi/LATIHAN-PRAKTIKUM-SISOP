#!/bin/bash
set -e

echo "1. Menyiapkan folder multi-user..."
mkdir -p multi_fs/{bin,dev,proc,sys,etc,tmp,root,home/{henn,hann,viii,kids}}
cd multi_fs

echo "2. Memasang BusyBox..."
wget -nc https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox -O bin/busybox
chmod +x bin/busybox
for cmd in $(./bin/busybox --list); do ln -s /bin/busybox bin/$cmd; done

echo "3. Konfigurasi User, Group, dan Password..."
# Generate hash MD5 otomatis untuk masing-masing password
PASS_ROOT=$(openssl passwd -1 root123)
PASS_HENN=$(openssl passwd -1 henn123)
PASS_HANN=$(openssl passwd -1 hann123)
PASS_VIII=$(openssl passwd -1 viii123)
PASS_KIDS=$(openssl passwd -1 kids123)

cat << EOF > etc/passwd
root:x:0:0:root:/root:/bin/sh
henn:x:1000:1000:henn:/home/henn:/bin/sh
hann:x:1001:1001:hann:/home/hann:/bin/sh
viii:x:1002:1002:viii:/home/viii:/bin/sh
kids:x:1003:1003:kids:/home/kids:/bin/sh
EOF

cat << EOF > etc/shadow
root:${PASS_ROOT}:19000:0:99999:7:::
henn:${PASS_HENN}:19000:0:99999:7:::
hann:${PASS_HANN}:19000:0:99999:7:::
viii:${PASS_VIII}:19000:0:99999:7:::
kids:${PASS_KIDS}:19000:0:99999:7:::
EOF

# Setup Group biar permissions sesuai tabel soal
cat << EOF > etc/group
root:x:0:
henn:x:1000:henn
hann:x:1001:henn,hann
viii:x:1002:henn,hann,viii
kids:x:1003:henn,hann,viii,kids
EOF

echo "4. Mengatur Hak Akses (Permissions)..."
# Default: cuma bisa read & execute
chmod 755 . bin dev proc sys etc home

# Full akses tmp/
chmod 777 tmp

# Akses root (cuma root yang bisa)
chown 0:0 root
chmod 700 root

# Akses Home Directories (Logika Group agar sesuai tabel akses)
chown 1000:1000 home/henn
chmod 770 home/henn

chown 1001:1001 home/hann
chmod 770 home/hann

chown 1002:1002 home/viii
chmod 770 home/viii

chown 1003:1003 home/kids
chmod 770 home/kids

echo "5. Membuat Banner (Farewell Party)..."
# File /etc/profile akan otomatis dieksekusi setelah user berhasil login
cat << 'EOF' > etc/profile
echo "  ___                             _ _ "
echo " | __|_ _ _ _ _____ __ _____| | |"
echo " | _/ _\` | '_/ -_) V  V / -_) | |"
echo " |_|\__,_|_| \___|\_/\_/\___|_|_|"
echo ""
echo "Welcome, $USER."
EOF

echo "6. Membuat script booting (init)..."
cat << 'EOF' > init
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

# Meluncurkan program login!
exec /bin/login
EOF
chmod +x init

echo "7. Membungkus menjadi multi.gz..."
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../osboot/multi.gz

cd ..
rm -rf multi_fs

echo "YEY! File multi.gz BERHASIL DIBUAT!"
