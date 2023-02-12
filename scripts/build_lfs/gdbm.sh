#!/bin/bash

mkdir -pv /build/gdbm
tar -xf /pkgs/gdbm-1.23.tar.gz              \
    -C /build/gdbm --strip-components 1

pushd /build/gdbm

./configure                 \
    --prefix=/usr           \
    --disable-static        \
    --enable-libgdbm-compat

make
make check > test_result.log
make install

popd