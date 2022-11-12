#! /bin/bash

# (c) Thomas Lange, 2002-2013, lange@cs.uni-koeln.de

# NOTE: Files named *.sh will be evaluated, but their output ignored.

[ $do_init_tasks -eq 1 ] || return 0 # Do only execute when doing install

echo 0 > /proc/sys/kernel/printk

# example how to load modules depending on the kernel version
#case $(uname -r) in
#    2.6*) kernelmodules="$kernelmodules mptspi dm-mod md-mod aes dm-crypt" ;;
#    [3456]*) kernelmodules="$kernelmodules mptspi dm-mod md-mod aes dm-crypt" ;;
#esac

for mod in $kernelmodules; do
    [ X$verbose = X1 ] && echo Loading kernel module $mod
    modprobe -a $mod 1>/dev/null 2>&1
done

# show the basic information about the network interface
ip -br li show up|egrep -v ^lo; ip -br a show up|egrep -v ^lo

echo $printk > /proc/sys/kernel/printk

odisklist=$disklist
set_disk_info  # recalculate list of available disks
if [ "$disklist" != "$odisklist" ]; then
    echo New disklist: $disklist
    echo disklist=\"$disklist\" >> $LOGDIR/additional.var
fi

save_dmesg     # save new boot messages (from loading modules)

