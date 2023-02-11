#!/bin/bash

mkdir -pv /build/check
tar -xf /pkgs/check-0.15.2.tar.gz           \
    -C /build/check --strip-components 1

pushd /build/check

./configure --prefix=/usr --disable-static

make

make check > test_result.log

make docdir=/usr/share/doc/check-0.15.2 install

popd
