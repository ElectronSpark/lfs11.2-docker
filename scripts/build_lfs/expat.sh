#!/bin/bash

mkdir -pv /build/expat
tar -xf /pkgs/expat-2.4.8.tar.xz            \
    -C /build/expat --strip-components 1

pushd /build/expat

./configure                             \
    --prefix=/usr                       \
    --disable-static                    \
    --docdir=/usr/share/doc/expat-2.4.8

make
make check > test_result.log
make install

# install documentation
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.4.8

popd
