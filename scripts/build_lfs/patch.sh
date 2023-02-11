#!/bin/bash

mkdir -pv /build/patch
tar -xf /pkgs/patch-2.7.6.tar.xz            \
    -C /build/patch --strip-components 1

pushd /build/patch

./configure --prefix=/usr

make

make check > test_result.log

make install

popd
