#!/bin/bash

mkdir -pv /{sources,build}/readline
tar -xf /pkgs/readline-8.1.2.tar.gz         \
    -C /sources/readline --strip-components 1

# to avoid the old libraries to be moved to <libraryname>.old while 
# reinstalling readline.
sed -i '/MV.*old/d' /sources/readline/Makefile.in
sed -i '/{OLDSUFF}/c:' /sources/readline/support/shlib-install

pushd /build/readline

/sources/readline/configure \
    --prefix=/usr           \
    --disable-static        \
    --with-curses           \
    --docdir=/usr/share/doc/readline-8.1.2

make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install
make install

install -v -m644 /sources/readline/doc/*.{ps,pdf,html,dvi}  \
    /usr/share/doc/readline-8.1.2

popd
