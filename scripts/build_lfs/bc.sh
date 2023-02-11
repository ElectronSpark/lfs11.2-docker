#!/bin/bash

mkdir -pv /build/bc
tar -xf /pkgs/bc-6.0.1.tar.xz           \
    -C /build/bc --strip-components 1

pushd /build/bc

CC=gcc ./configure --prefix=/usr -G -O3 -r
make prefix=/usr
make test > test_result.log
make prefix=/usr install

popd
