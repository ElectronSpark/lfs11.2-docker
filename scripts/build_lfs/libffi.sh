#!/bin/bash

mkdir -pv /{build,sources}/libffi
tar -xf /pkgs/libffi-3.4.2.tar.gz        \
    -C /sources/libffi --strip-components 1

pushd /build/libffi

/sources/libffi/configure       \
    --prefix=/usr               \
    --disable-static            \
    --with-gcc-arch=native      \
    --disable-exec-static-tramp

make

make check > test_result.log

make install

popd
