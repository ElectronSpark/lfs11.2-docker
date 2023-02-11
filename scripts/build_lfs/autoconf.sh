#!/bin/bash

mkdir -pv /build/autoconf
tar -xf /pkgs/autoconf-2.71.tar.xz              \
    -C /build/autoconf --strip-components 1

pushd /build/autoconf

./configure --prefix=/usr

make
make check > test_result.log
make install

popd
