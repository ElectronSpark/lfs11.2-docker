#!/bin/bash

mkdir -pv /{build,sources}/less
tar -xf /pkgs/less-590.tar.gz               \
    -C /sources/less --strip-components 1

pushd /build/less

/sources/less/configure     \
    --prefix=/usr           \
    --sysconfdir=/etc

make
make install

popd
