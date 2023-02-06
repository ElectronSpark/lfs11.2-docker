#!/bin/bash

mkdir -pv /{build,sources}/grep
tar -xf /pkgs/grep-3.7.tar.xz               \
    -C /sources/grep --strip-components 1

pushd /build/grep

/sources/grep/configure --prefix=/usr

make
make check > test_result.log
make install

popd
