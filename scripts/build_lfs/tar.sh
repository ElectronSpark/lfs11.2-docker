#!/bin/bash

mkdir -pv /build/tar
tar -xf /pkgs/tar-1.34.tar.xz               \
    -C /build/tar --strip-components 1

pushd /build/tar

# FORCE_UNSAFE_CONFIGURE will force the test for mknod to be run as root.
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr

make

# one test, capacities: binary store/restore, is known to fail
make check > test_result.log

make install
make -C doc install-html docdir=/usr/share/doc/tar-1.34

popd
