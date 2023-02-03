#!/bin/bash
#
# This program does the final preparations before entering chroot environment,
# and then builds additional temporary tools.
#
# The following script need to be running while logged in as user root and no 
# longer as user lfs.

# change the ownership of the ${LFS}/* directories to user root
chown -R root:root ${LFS}/{usr,lib,var,etc,bin,sbin,tools}
# my computer is 64 bits, and this command may cause problems in other machines.
chown -R root:root ${LFS}/lib64

# preparing virtual kernel file system
mkdir -pv ${LFS}/{dev,proc,sys,run}

# mount and populate the host system's /dev directory
# @TODO: not populating /dev fs may cause problem, but this action is commented
#       there because permission was denied under unprivileged docker 
#       environment.
mount -v --bind /dev ${LFS}/dev

# mount the remaining virtual kernel filesystems
mount -v --bind /dev/pts ${LFS}/dev/pts
mount -vt proc proc ${LFS}/proc
mount -vt sysfs sysfs ${LFS}/sys
mount -vt tmpfs tmpfs ${LFS}/run
# in some host systems, /dev/shm is a symbolic link to /run/shm.
if [ -h ${LFS}/dev/shm ]; then
    mkdir -pv ${LFS}/$(readlink ${LFS}/dev/shm)
fi

# enter the chroot environment
chroot "${LFS}" /usr/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$'  \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login -c "/scripts/run_all.sh on_chroot"

# @TODO: the following line will be executed after the chroot envoronment 
#       logout.