#!/bin/bash
#
# This program mounts all the file systems needed for chroot to operate.
#
# The following script need to be running while logged in as user root and no 
# longer as user lfs.

# mount and populate the host system's /dev directory
mount -v --bind /dev ${LFS}/dev

# mount the remaining virtual kernel filesystems
mount -v --bind /dev/pts ${LFS}/dev/pts
mount -vt proc proc ${LFS}/proc
mount -vt sysfs sysfs ${LFS}/sys
mount -vt tmpfs tmpfs ${LFS}/run
