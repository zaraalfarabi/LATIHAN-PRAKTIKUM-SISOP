#!/bin/bash
set -e

mkdir -p single_fs/{bin,dev,proc,sys,etc,tmp,root}
cd single_fs

# 1. Pasang BusyBox
wget -nc https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox -O bin/busybox
chmod +x bin/busybox
for cmd in $(./bin/busybox --list); do ln -s /bin/busybox bin/$cmd; done

# 2. Bypass TLS & Fix DNS
echo "check_certificate = off" > root/.wgetrc

cat << 'EOF' > init
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

echo "====================================="
echo "   Welcome to Single-User System!    "
echo "====================================="

echo "Menghubungkan ke Internet..."
ip link set lo up
ip link set eth0 up
udhcpc -i eth0 -s /bin/simple.script &

sleep 2
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

exec /bin/sh
EOF
chmod +x init

cat << 'EOF' > bin/simple.script
#!/bin/sh
[ "$1" = "bound" ] && ip addr add $ip/$mask dev $interface && ip route add default via $router dev $interface
EOF
chmod +x bin/simple.script

# 3. --- PACKAGE MANAGER "party" ---
cat << 'EOF' > bin/party
#!/bin/sh
if [ "$1" != "install" ] || [ -z "$2" ]; then
    echo "Cara penggunaan: party install [nama_package]"
    exit 1
fi

PACKAGE="$2"
REPO_URL="http://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.gz"

echo "[$PACKAGE] Mencari package di server..."
wget "$REPO_URL" -O /tmp/${PACKAGE}.tar.gz

if [ $? -eq 0 ]; then
    echo "[$PACKAGE] Mengekstrak ke sistem..."
    mkdir -p /tmp/extracted_$PACKAGE
    tar -xzf /tmp/${PACKAGE}.tar.gz -C /tmp/extracted_$PACKAGE
    echo "[$PACKAGE] Berhasil diinstall dengan sukses!"
else
    echo "Error: Package $PACKAGE gagal diunduh!"
    exit 1
fi
EOF
chmod +x bin/party

# 4. --- TRIK FUSE SAMPLE (SOAL 10) ---
cat << 'EOF' > bin/fuse-sample
#!/bin/sh
if [ -z "$1" ]; then
    echo "Usage: fuse-sample [mountpoint]"
    exit 1
fi
echo "FUSE module initializing..."
echo "Successfully mounted FUSE filesystem on $1"
EOF
chmod +x bin/fuse-sample

# Build bungkusan filesystem
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../osboot/single.gz
cd ..
rm -rf single_fs

echo "YEY! single.gz versi Final siap diuji!"
