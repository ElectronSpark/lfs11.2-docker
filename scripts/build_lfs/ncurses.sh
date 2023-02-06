#!/bin/bash

mkdir -pv /{build,sources}/ncurses
tar -xf /pkgs/ncurses-6.3.tar.gz                    \
    -C /sources/ncurses --strip-components 1

pushd /build/ncurses

/sources/ncurses/configure      \
    --prefix=/usr               \
    --mandir=/usr/share/man     \
    --with-shared               \
    --without-debug             \
    --without-normal            \
    --with-cxx-shared           \
    --enable-pc-files           \
    --enable-widec              \
    --with-pkg-config-libdir=/usr/lib/pkgconfig

make

# ncurses' test suite can only run after it's been installed, and install it
# directly will override libncursesw.so.6.3, wich may crach the shell process
# because it's using code and data from the library file.
make DESTDIR=$PWD/dest install
# replace the library file correctly using install command.
install -vm755 dest/usr/lib/libncursesw.so.6.3 /usr/lib
# remove a useless *static* archive
rm -v dest/usr/lib/libncursesw.so.6.3
cp -av dest/* /

# trick those applications expecting the linker to be able to find 
# non-wide-character version ncurses library into linking with
# wide-character version of it.
for lib in ncurses form panel menu ; do
    rm -vf  /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc  /usr/lib/pkgconfig/${lib}.pc
done

# make sure that old applications that look for -lcurses at build time are
# still buildable.
rm -vf  /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so   /usr/lib/libcurses.so

# install the ncurses documentation
mkdir -pv   /usr/share/doc/ncurses-6.3
cp -v -R /sources/ncurses/doc/* /usr/share/doc/ncurses-6.3

popd
