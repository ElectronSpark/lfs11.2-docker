#!/bin/bash

mkdir -pv /build/xz
tar -xf /pkgs/xz-5.2.6.tar.xz               \
    -C /build/xz --strip-components 1

pushd /build/xz

./configure                         \
    --prefix=/usr                   \
    --disable-static                \
    --docdir=/usr/share/doc/xz-5.2.6

make
make check > test_result.log
make install

popd
