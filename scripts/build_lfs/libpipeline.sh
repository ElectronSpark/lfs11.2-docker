#!/bin/bash

mkdir -pv /build/libpipeline
tar -xf /pkgs/libpipeline-1.5.6.tar.gz  \
    -C /build/libpipeline --strip-components 1

pushd /build/libpipeline

./configure --prefix=/usr

make

make check > test_result.log

make install

popd
