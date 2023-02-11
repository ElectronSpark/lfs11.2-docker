#!/bin/bash

mkdir -pv /build/groff
tar -xf /pkgs/groff-1.22.4.tar.gz               \
    -C /build/groff --strip-components 1

pushd /build/groff

PAGE=A4 ./configure --prefix=/usr

# this package doesn't support parallel build
make -j1

make install

popd
