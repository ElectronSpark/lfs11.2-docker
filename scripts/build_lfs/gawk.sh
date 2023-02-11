#!/bin/bash

mkdir -pv /build/gawk
tar -xf /pkgs/gawk-5.1.1.tar.xz             \
    -C /build/gawk --strip-components 1

pushd /build/gawk

# make sure some unneeded files are not installed
sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

make check > test_result.log

make install

# install the documentation
mkdir -pv   /usr/share/doc/gawk-5.1.1
cp  -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.1

popd
