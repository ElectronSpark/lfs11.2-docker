#!/bin/bash

mkdir -pv /build/openssl
tar -xf /pkgs/openssl-3.0.5.tar.gz              \
    -C /build/openssl --strip-components 1

pushd /build/openssl

./config                    \
    --prefix=/usr           \
    --openssldir=/etc/ssl   \
    --libdir=lib            \
    shared                  \
    zlib-dynamic

make
make test > test_result.log

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.0.5

cp -vfr doc/* /usr/share/doc/openssl-3.0.5

popd
