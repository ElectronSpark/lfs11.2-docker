#!/bin/bash

mkdir -pv /{build,sources}/expat
tar -xf /pkgs/inetutils-2.3.tar.xz          \
    -C /sources/expat --strip-components 1

pushd /build/expat

/sources/expat/configure    \
    --prefix=/usr           \
    --disable-static        \
    --docdir=/usr/share/doc/expat-2.4.8

make
make check > test_result.log
make install

# install documentation
install -v -m644 /sources/expat/doc/*.{html,css} /usr/share/doc/expat-2.4.8

popd
