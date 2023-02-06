#!/bin/bash

mkdir -pv /{build,sources}/libtool
tar -xf /pkgs/libtool-2.4.7.tar.xz          \
    -C /sources/libtool --strip-components 1

pushd /build/libtool

/sources/libtool/configure --prefix=/usr

make
make check > test_result.log
make install
# remove a useless static library
rm -fv /usr/lib/libltdl.a

popd
