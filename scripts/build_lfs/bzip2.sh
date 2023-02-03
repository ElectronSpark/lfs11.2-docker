#!/bin/bash

mkdir -pv /build/bzip2
tar -xf /pkgs/bzip2-1.0.8.tar.gz                    \
    -C /build/bzip2 --strip-components 1

pushd /build/bzip2

patch -Np1 -i /sources/bzip2-1.0.8-install_docs-1.patch
# ensure installation of symbolic links are relative
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
# ensure the man pages are installed into the correct location
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

# this will cause Bzip2 to be built using Makefile-libbz2_so
make -f Makefile-libbz2_so
make clean

make
make PREFIX=/usr install
# install the shared libraries
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
# install the shared bzip2 binary into /usr/bin directory, and replace two
# copies of bzip2 with symlinks
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
    ln -sfv bzip2 $i
done

# remove useless static library
rm -fv /usr/lib/libbz2.a

popd
