#!/bin/bash

# tell perl not to build internal zlib and bzip2
export BUILD_ZLIB=False
export BUILD_BZIP2=0

mkdir -pv /build/perl
tar -xf /pkgs/perl-5.36.0.tar.xz            \
    -C /build/perl --strip-components 1

pushd /build/perl

sh Configure                                        \
    -des                                            \
    -Dprefix=/usr                                   \
    -Dvendorprefix=/usr                             \
    -Dprivlib=/usr/lib/perl5/5.36/core_perl         \
    -Darchlib=/usr/lib/perl5/5.36/core_perl         \
    -Dsitelib=/usr/lib/perl5/5.36/site_perl         \
    -Dsitearch=/usr/lib/perl5/5.36/site_perl        \
    -Dvendorlib=/usr/lib/perl5/5.36/vendor_perl     \
    -Dvendorarch=/usr/lib/perl5/5.36/vendor_perl    \
    -Dman1dir=/usr/share/man/man1                   \
    -Dman3dir=/usr/share/man/man3                   \
    -Dpager="/usr/bin/less -isR"                    \
    -Duseshrplib                                    \
    -Dusethreads

make
make check > test_result.log

make install
unset BUILD_ZLIB BUILD_BZIP2

popd
