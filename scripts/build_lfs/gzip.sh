#!/bin/bash

mkdir -pv /build/gzip
tar -xf /pkgs/gzip-1.12.tar.xz              \
    -C /build/gzip --strip-components 1

pushd /build/gzip

./configure --prefix=/usr

make

make check > test_result.log

make install

popd
