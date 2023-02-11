#!/bin/bash

mkdir -pv /build/zlib
tar -xf /pkgs/zlib-1.2.12.tar.xz                    \
    -C /build/zlib --strip-components 1

pushd /build/zlib

./configure --prefix=/usr

make
make check > test_result.log
make install
# remove a useless static library
rm -fv /usr/lib/libz.a

popd
