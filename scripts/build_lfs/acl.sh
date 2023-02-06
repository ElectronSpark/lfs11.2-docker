#!/bin/bash

mkdir -pv /build/acl
tar -xf /pkgs/acl-2.3.1.tar.xz          \
    -C /build/acl --strip-components 1

pushd /build/acl

./configure                         \
    --prefix=/usr                   \
    --disable-static                \
    --docdir=/usr/share/doc/acl-2.3.1

make
make install

popd
