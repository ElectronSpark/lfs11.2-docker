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

sh mount_devs.sh

# in some host systems, /dev/shm is a symbolic link to /run/shm.
if [ -h ${LFS}/dev/shm ]; then
    mkdir -pv ${LFS}/$(readlink ${LFS}/dev/shm)
fi
