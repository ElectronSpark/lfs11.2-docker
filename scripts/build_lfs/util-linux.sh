#!/bin/bash

mkdir -pv /build/util-linux
tar -xf /pkgs/util-linux-2.38.1.tar.xz  \
    -C /build/util-linux --strip-components 1

pushd /build/util-linux

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
    --bindir=/usr/bin                               \
    --libdir=/usr/lib                               \
    --sbindir=/usr/sbin                             \
    --docdir=/usr/share/doc/util-linux-2.38.1       \
    --disable-chfn-chsh                             \
    --disable-login                                 \
    --disable-nologin                               \
    --disable-su                                    \
    --disable-setpriv                               \
    --disable-runuser                               \
    --disable-pylibmount                            \
    --disable-static                                \
    --without-python

make

chown -Rv tester .
su tester -c "make -k check"

make install

popd
