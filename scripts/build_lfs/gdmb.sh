#!/bin/bash

mkdir -pv /{build,sources}/gdbm
tar -xf /pkgs/gdbm-1.23.tar.gz              \
    -C /sources/gdbm --strip-components 1

pushd /build/gdbm

/sources/gdbm/configure     \
    --prefix=/usr           \
    --disable-static        \
    --enable-libgdbm-compat

make
make check > test_result.log
make install

popd