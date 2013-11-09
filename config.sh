#!/bin/sh

# usage: ask question default
# asking in stderr
ask() {
  local ans
  echo -n "${1} [${2}]: " >&2
  read ans
  [ -n "${ans}" ] && echo "${ans}" || echo "${2}"
}

ROOT=$(ask 'rootfs' 'zroot/ROOT')
POOL=$(ask 'pool' $(echo $ROOT|cut -d/ -f1))
INIT=$(ask 'init' '/sbin/init')

cat >vars <<EOF
ROOT="${ROOT}"
POOL="${POOL}"
INIT="${INIT}"
EOF
