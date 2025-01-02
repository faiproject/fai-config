#! /bin/bash

# use short hostname instead of FQDN
export HOSTNAME=${HOSTNAME%%.*}
if inside_nfsroot; then
  echo $HOSTNAME > /proc/sys/kernel/hostname
fi
