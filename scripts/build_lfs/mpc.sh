#!/bin/bash

mkdir -pv /build/mpc
tar -xf /pkgs/mpc-1.2.1.tar.gz         \
    -C /build/mpc --strip-components 1

pushd /build/mpc

./configure                         \
    --prefix=/usr                   \
    --disable-static                \
    --docdir=/usr/share/doc/mpc-1.2.1

make
make html

make check > test_result.log

make install
make install-html

popd
