#! /bin/bash

# The linux-image package has different names for Debian and Ubuntu


if ifclass UBUNTU; then
    kernelname=linux-image-generic
else
    _arch=$(dpkg --print-architecture 2>/dev/null)
    case $_arch in
        i386)
            kernelname=linux-image-686-pae ;;
        *)
            kernelname=linux-image-$_arch
    esac
    unset _arch
fi

echo kernelname=\"$kernelname\" >> $LOGDIR/additional.var
