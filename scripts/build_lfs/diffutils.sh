#!/bin/bash

mkdir -pv /{build,sources}/diffutils
tar -xf /pkgs/diffutils-3.8.tar.xz          \
    -C /sources/diffutils --strip-components 1

pushd /build/diffutils

/sources/diffutils/configure --prefix=/usr

make

make check > test_result.log

make install

popd
