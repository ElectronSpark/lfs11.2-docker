#!/bin/bash

mkdir -pv /build/file
tar -xf /pkgs/file-5.42.tar.gz                  \
    -C /build/file --strip-components 1

pushd /build/file

./configure --prefix=/usr

make
make check > test_result.log
make install

popd
