#!/bin/bash

mkdir -pv /build/less
tar -xf /pkgs/less-590.tar.gz               \
    -C /build/less --strip-components 1

pushd /build/less

./configure --prefix=/usr --sysconfdir=/etc

make
make install

popd
