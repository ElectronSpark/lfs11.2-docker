#!/bin/bash

if [ -n $1 ]; then
    chroot "${LFS}" /usr/bin/env -i \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$'  \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS='${MAKEFLAGS}'    \
        /bin/bash --login -c $1
else
    chroot "${LFS}" /usr/bin/env -i \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$'  \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS='${MAKEFLAGS}'    \
        /bin/bash
fi
