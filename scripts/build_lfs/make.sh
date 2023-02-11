#!/bin/bash

mkdir -pv /build/make
tar -xf /pkgs/make-4.3.tar.gz           \
    -C /build/make --strip-components 1

pushd /build/make

./configure --prefix=/usr

make

make check > test_result.log

make install

popd
