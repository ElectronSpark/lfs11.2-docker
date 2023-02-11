#!/bin/bash

mkdir -pv /build/man-db
tar -xf /pkgs/man-db-2.10.2.tar.xz      \
    -C /build/man-db --strip-components 1

pushd /build/man-db

./configure                                 \
    --prefix=/usr                           \
    --docdir=/usr/share/doc/man-db-2.10.2   \
    --sysconfdir=/etc                       \
    --disable-setuid                        \
    --enable-cache-owner=bin                \
    --with-browser=/usr/bin/lynx            \
    --with-vgrind=/usr/bin/vgrind           \
    --with-grap=/usr/bin/grap

make

make check > test_result.log

make install

ln -sfv /etc/machine-id /var/lib/dbus

popd
