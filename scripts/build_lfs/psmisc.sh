#!/bin/bash

mkdir -pv /build/psmisc
tar -xf /pkgs/psmisc-23.5.tar.xz                \
    -C /build/psmisc --strip-components 1

pushd /build/psmisc

./configure --prefix=/usr

make
make install

popd
