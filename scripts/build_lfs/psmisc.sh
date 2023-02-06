#!/bin/bash

mkdir -pv /{build,sources}/psmisc
tar -xf /pkgs/psmisc-23.5.tar.xz                \
    -C /sources/psmisc --strip-components 1

pushd /build/psmisc

/sources/psmisc/configure --prefix=/usr

make
make install

popd
