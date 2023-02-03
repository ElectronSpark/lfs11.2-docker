#!/bin/bash

mkdir -pv /{build,sources}/xz
tar -xf /pkgs/xz-5.2.6.tar.xz               \
    -C /sources/xz --strip-components 1

pushd /build/xz

/sources/xz/configure               \
    --prefix=/usr                   \
    --disable-static                \
    --docdir=/usr/share/doc/xz-5.2.6

make
make check > test_result.log
make install

popd
