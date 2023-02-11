#!/bin/bash

mkdir -pv /build/m4
tar -xf /pkgs/m4-1.4.19.tar.xz                  \
    -C /build/m4 --strip-components 1

pushd /build/m4

./configure --prefix=/usr

make
make check > test_result.log
make install

popd
