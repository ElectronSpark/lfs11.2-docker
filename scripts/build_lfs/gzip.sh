#!/bin/bash

mkdir -pv /{build,sources}/gzip
tar -xf /pkgs/gzip-1.12.tar.xz              \
    -C /sources/gzip --strip-components 1

pushd /build/gzip

/sources/gzip/configure --prefix=/usr

make

make check > test_result.log

make install

popd
