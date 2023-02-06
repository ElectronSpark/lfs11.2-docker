#!/bin/bash

mkdir -pv /{build,sources}/openssl
tar -xf /pkgs/openssl-3.0.5.tar.gz              \
    -C /sources/openssl --strip-components 1

pushd /build/openssl

/sources/openssl/config     \
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

cp -vfr /sources/openssl/doc/* /usr/share/doc/openssl-3.0.5

popd
