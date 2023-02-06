#!/bin/bash

mkdir -pv /{build,sources}/bison
tar -xf /pkgs/bison-3.8.2.tar.xz                \
    -C /sources/bison --strip-components 1

pushd /build/bison

/sources/bison/configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make
make check > test_result.log
make install

popd
