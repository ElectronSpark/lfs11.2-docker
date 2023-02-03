#!/bin/bash

mkdir -pv /build/dejagnu
tar -xf /pkgs/dejagnu-1.6.3.tar.gz          \
    -C /build/dejagnu --strip-components 1

pushd /build/dejagnu

mkdir -v build
cd build
../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi

make install
install -v -dm755 /usr/share/doc/dejagnu-1.6.3
install -v -m644 doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3
make check > test_result.log

popd
