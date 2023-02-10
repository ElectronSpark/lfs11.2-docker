#!/bin/bash

if [ $# -gt 0 ]; then
    echo "entering chroot environment with -c '$1'"
    sudo chroot "${LFS}" /usr/bin/env -i    \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$'  \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS="${MAKEFLAGS}"    \
        /bin/bash --login -c '$1'
else
    echo "entering chroot environment without parameter"
    sudo chroot "${LFS}" /usr/bin/env -i    \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$'  \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS="${MAKEFLAGS}"    \
        /bin/bash --login
fi
