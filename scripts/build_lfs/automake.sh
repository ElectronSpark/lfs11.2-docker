#!/bin/bash

mkdir -pv /build/automake
tar -xf /pkgs/automake-1.16.5.tar.xz            \
    -C /build/automake --strip-components 1

pushd /build/automake

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.5

make
make check > test_result.log
make install

popd
