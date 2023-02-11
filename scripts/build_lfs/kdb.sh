#!/bin/bash

mkdir -pv /build/kdb
tar -xf /pkgs/kbd-2.5.1.tar.xz          \
    -C /build/kdb --strip-components 1

pushd /build/kdb

# this patch will fix the problem on backspace and delete key for i386 keymaps
patch -Np1 -i /pkgs/kbd-2.5.1-backspace-1.patch

# remove redundant resizecons program and its manpage.
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

make check > test_result.log

make install

# install the documentation
mkdir -pv   /usr/share/doc/kbd-2.5.1
cp -R -v docs/doc/* /usr/share/doc/kbd-2.5.1

popd
