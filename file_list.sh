#!/bin/sh

(
# static part

cat <<EOF
dir /proc 0755 0 0
dir /sys 0755 0 0
dir /dev 0755 0 0
dir /bin 0755 0 0
dir /sbin 0755 0 0
dir /lib64 0755 0 0
slink /lib lib64 0777 0 0
dir /etc 0755 0 0
dir /newroot 0755 0 0

nod /dev/console 0600 0 0 c 5 1
nod /dev/null 0666 0 0 c 1 3
nod /dev/zero 0666 0 0 c 1 5

file /init /usr/src/initramfs/init 0755 0 0
file /vars /usr/src/initramfs/vars 0644 0 0
file /etc/mtab /dev/null 0644 0 0
file /bin/busybox /bin/busybox 0755 0 0
file /sbin/zfs /sbin/zfs 0755 0 0
file /sbin/zpool /sbin/zpool 0755 0 0
file /sbin/mount.zfs /sbin/mount.zfs 0755 0 0
EOF

) | (
# dynamic part

while read s1 s2 s3 rest; do
  echo $s1 $s2 $s3 $rest
  if [ "x$s1" = "xfile" ]; then
    ldd "$s3" 2>/dev/null | grep '/' | awk '{print $(NF-1)}' | (
      while read lib; do
        echo file $lib $lib $(stat -L --printf="%.4a" $lib) 0 0
      done
    )
  fi
done

) | sort -u -k 2

