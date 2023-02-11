#!/bin/bash

mkdir -pv /build/libelf
tar -xf /pkgs/elfutils-0.187.tar.bz2        \
    -C /build/libelf --strip-components 1

pushd /build/libelf

./configure                     \
    --prefix=/usr               \
    --disable-debuginfod        \
    --enable-libdebuginfod=dummy

make

# @TODO: some tests failed.
make check > test_result.log

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

popd