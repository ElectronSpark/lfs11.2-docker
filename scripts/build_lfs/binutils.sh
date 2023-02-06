#!/bin/bash

# this test is better to be done before running the test suites for binutils
# and gcc.
# expect -c "spawn ls"

mkdir -pv /{build,sources}/binutils
tar -xf /pkgs/binutils-2.39.tar.xz          \
    -C /sources/binutils --strip-components 1

pushd /build/binutils

/sources/binutils/configure             \
    --prefix=/usr                       \
    --sysconfdir=/etc                   \
    --enable-gold                       \
    --enable-ld=default                 \
    --enable-plugins                    \
    --enable-shared                     \
    --disable-werror                    \
    --enable-64-bit-bfd                 \
    --with-system-zlib

make tooldir=/usr
make -k check > test_result.log
make tooldir=/usr install

# remove useless static libraries
rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a

popd
