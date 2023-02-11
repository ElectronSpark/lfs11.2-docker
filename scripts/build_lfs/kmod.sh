#!/bin/bash

mkdir -pv /build/kmod
tar -xf /pkgs/kmod-30.tar.xz                    \
    -C /build/kmod --strip-components 1

pushd /build/kmod

./configure                 \
    --prefix=/usr           \
    --sysconfdir=/etc       \
    --with-openssl          \
    --with-xz               \
    --with-zstd             \
    --with-zlib

make

make install

for target in depmod insmod modinfo modprobe rmmod; do
    ln -sfv ../bin/kmod /usr/sbin/$target
done
ln -sfv kmod /usr/bin/lsmod

popd
