#! /bin/bash

# (c) Thomas Lange, 2002-2026, lange@cs.uni-koeln.de

# NOTE: Files named *.sh will be sourced, but their output is ignored.

inside_nfsroot || return 0 # Do only execute when doing install

echo 0 > /proc/sys/kernel/printk

kernelmodules+=" md-mod"
for mod in $kernelmodules; do
    [ X$verbose = X1 ] && echo Loading kernel module $mod
    modprobe -a $mod 1>/dev/null 2>&1
done
unset mod

# show the basic information about the network interface
ip -br li show up|egrep -v ^lo; ip -br a show up|egrep -v ^lo

echo $printk > /proc/sys/kernel/printk

save_dmesg     # save new boot messages (from loading modules)

