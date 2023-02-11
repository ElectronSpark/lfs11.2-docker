#!/bin/bash

mkdir -pv /build/libffi
tar -xf /pkgs/libffi-3.4.2.tar.gz        \
    -C /build/libffi --strip-components 1

pushd /build/libffi

./configure                     \
    --prefix=/usr               \
    --disable-static            \
    --with-gcc-arch=native      \
    --disable-exec-static-tramp

make

make check > test_result.log

make install

popd
