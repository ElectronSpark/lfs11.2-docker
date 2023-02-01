#!/bin/bash
# This programs downloads all the packages needed to "~/sources".
# If a tarball contains all these packages is detected, then just extract its
# contents to "~/sources".

if [ -f ${LFS_HOME}/pkgs/lfs-packages-11.2.tar ]; then
    tar vxf ${LFS_HOME}/pkgs/lfs-packages-11.2.tar  \
        -C ${LFS_HOME}/sources --strip-components=1
else
    wget --input-file=${LFS_HOME}/pkgs/wget-list --continue \
        --directory-prefix=${LFS_HOME}/sources
fi

# check md5sum
pushd ${LFS_HOME}/sources
    md5sum -c md5sums
popd

cp -rv ${LFS_HOME}/sources ${LFS}/
