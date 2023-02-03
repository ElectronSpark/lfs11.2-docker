#!/bin/bash

mkdir -pv /{sources,build}/flex
tar -xf /pkgs/flex-2.6.4.tar.gz                 \
    -C /sources/flex --strip-components 1

pushd /build/flex

/sources/flex/configure \
    --prefix=/usr       \
    --disable-static    \
    --docdir=/usr/share/doc/flex-2.6.4

make
make check > test_result.log
make install

# to make programs run lex to run flex
ln -sv flex /usr/bin/lex

popd
