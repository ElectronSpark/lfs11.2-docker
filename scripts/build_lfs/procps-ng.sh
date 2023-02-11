#!/bin/bash

mkdir -pv /build/procps-ng
tar -xf /pkgs/procps-ng-4.0.0.tar.xz    \
    -C /build/procps-ng --strip-components 1

pushd /build/procps-ng

./configure                                 \
    --prefix=/usr                           \
    --docdir=/usr/share/doc/procps-ng-4.0.0 \
    --disable-static                        \
    --disable-kill                          \
    --with-systemd

make

make check > test_result.log

make install

popd
