#!/bin/bash

mkdir -pv /build/grep
tar -xf /pkgs/grep-3.7.tar.xz               \
    -C /build/grep --strip-components 1

pushd /build/grep

./configure --prefix=/usr

make
make check > test_result.log
make install

popd
