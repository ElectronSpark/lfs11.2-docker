#!/bin/bash

mkdir -pv /build/flex
tar -xf /pkgs/flex-2.6.4.tar.gz                 \
    -C /build/flex --strip-components 1

pushd /build/flex

./configure             \
    --prefix=/usr       \
    --disable-static    \
    --docdir=/usr/share/doc/flex-2.6.4

make
make check > test_result.log
make install

# to make programs run lex to run flex
ln -sv flex /usr/bin/lex

popd
