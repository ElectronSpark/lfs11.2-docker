#!/bin/bash

mkdir -pv /build/pkg-config
tar -xf /pkgs/pkg-config-0.29.2.tar.gz      \
    -C /build/pkg-config --strip-components 1

pushd /build/pkg-config

./configure                         \
    --prefix=/usr                   \
    --with-internal-glib            \
    --disable-host-tool             \
    --docdir=/usr/share/doc/pkg-config-0.29.2

make
make check > test_result.log
make install

popd
