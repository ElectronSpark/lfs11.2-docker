#!/bin/bash

mkdir -pv /build/expect
tar -xf /pkgs/expect5.45.4.tar.gz           \
    -C /build/expect --strip-components 1

pushd /build/expect

./configure                         \
    --prefix=/usr                   \
    --with-tcl=/usr/lib             \
    --enable-shared                 \
    --mandir=/usr/share/man         \
    --with-tclinclude=/usr/include

make
make test > test_result.log
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

popd
