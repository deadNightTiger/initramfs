#!/bin/sh

[ -e "./vars" ] || ./config.sh
OUT="${1:-/boot/initramfs.xz}"
FILELIST=$(mktemp)
./file_list.sh > $FILELIST
(cd /usr/src/linux && scripts/gen_initramfs_list.sh -o "$OUT" "$FILELIST")
rm "$FILELIST"
