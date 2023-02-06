#!/bin/bash

mkdir -pv /{build,sources}/autoconf
tar -xf /pkgs/autoconf-2.71.tar.xz              \
    -C /sources/autoconf --strip-components 1

pushd /build/autoconf

/sources/autoconf/configure --prefix=/usr

make
make check > test_result.log
make install

popd
