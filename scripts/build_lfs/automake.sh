#!/bin/bash

mkdir -pv /{build,sources}/automake
tar -xf /pkgs/automake-1.16.5.tar.xz            \
    -C /sources/automake --strip-components 1

pushd /build/automake

/sources/automake/configure     \
    --prefix=/usr               \
    --docdir=/usr/share/doc/automake-1.16.5

make
make check > test_result.log
make install

popd
