#!/bin/bash

# @TODO: This package didn't pass all test suites which are essential.

mkdir -pv /build/gmp
tar -xf /pkgs/gmp-6.2.1.tar.xz              \
    -C /build/gmp --strip-components 1

pushd /build/gmp

# libraries suitable for processors less capable than the host's CPU are desired
cp -v configfsf.guess config.guess
cp -v configfsf.sub config.sub

./configure                         \
    --build=x86_64-pc-linux-gnu     \
    --prefix=/usr                   \
    --enable-cxx                    \
    --disable-static                \
    --docdir=/usr/share/doc/gmp-6.2.1

make
make html

make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

popd
