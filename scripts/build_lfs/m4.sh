#!/bin/bash

mkdir -pv /{sources,build}/m4
tar -xf /pkgs/m4-1.4.19.tar.xz                  \
    -C /sources/m4 --strip-components 1

pushd /build/m4

/sources/m4/configure --prefix=/usr

make
make check > test_result.log
make install

popd
