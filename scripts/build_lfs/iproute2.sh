#!/bin/bash

mkdir -pv /build/iproute2
tar -xf /pkgs/iproute2-5.19.0.tar.xz    \
    -C /build/iproute2 --strip-components 1

pushd /build/iproute2

# arpd will not be installed here because LFS doesn't have Berkeley DB, but a
# directory for arpd and a man page are still need to be installed.
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

# compile the package
make NETNS_RUN_DIR=/run/netns

# install the package
make SBINDIR=/usr/sbin install

# install the documentation
mkdir -pv   /usr/share/doc/iproute2-5.19.0
cp -v COPYING README* /usr/share/doc/iproute2-5.19.0

popd
