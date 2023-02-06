#!/bin/bash

mkdir -pv /build/attr
tar -xf /pkgs/attr-2.5.1.tar.gz         \
    -C /build/attr --strip-components 1

pushd /build/attr

./configure                         \
    --prefix=/usr                   \
    --disable-static                \
    --sysconfdir=/etc               \
    --docdir=/usr/share/doc/attr-2.5.1

make
make check > test_result.log
make install

popd
