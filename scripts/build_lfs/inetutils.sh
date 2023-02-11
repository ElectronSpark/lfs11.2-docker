#!/bin/bash

mkdir -pv /build/inetutils
tar -xf /pkgs/inetutils-2.3.tar.xz          \
    -C /build/inetutils --strip-components 1

pushd /build/inetutils

./configure                     \
    --prefix=/usr               \
    --bindir=/usr/bin           \
    --localstatedir=/var        \
    --disable-logger            \
    --disable-whois             \
    --disable-rcp               \
    --disable-rexec             \
    --disable-rlogin            \
    --disable-rsh               \
    --disable-servers

make
make check > test_result.log
make install

# move program to the proper location
mv -v /usr/{,s}bin/ifconfig

popd