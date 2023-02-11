#!/bin/bash

mkdir -pv /build/readline
tar -xf /pkgs/readline-8.1.2.tar.gz         \
    -C /build/readline --strip-components 1
pushd /build/readline

# to avoid the old libraries to be moved to <libraryname>.old while 
# reinstalling readline.
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure                 \
    --prefix=/usr           \
    --disable-static        \
    --with-curses           \
    --docdir=/usr/share/doc/readline-8.1.2

make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install
make install

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1.2

popd
