#!/bin/bash

mkdir -pv /build/mpfr
tar -xf /pkgs/mpfr-4.1.0.tar.xz         \
    -C /build/mpfr --strip-components 1

pushd /build/mpfr

./configure                         \
    --prefix=/usr                   \
    --disable-static                \
    --enable-thread-safe            \
    --docdir=/usr/share/doc/mpfr-4.1.0

make
make html

make check > test_result.log

make install
make install-html

popd
