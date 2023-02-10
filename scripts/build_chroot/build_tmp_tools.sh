#!/bin/bash
#
# This program builds the rest temporary tools under chroot environment.
#

# gettext
mkdir -pv /build/gettext-tmp
tar -xf /pkgs/gettext-0.21.tar.xz   \
    -C /build/gettext-tmp --strip-components 1

pushd /build/gettext-tmp

./configure --disable-shared

make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

popd


# bison
mkdir -pv /build/bison-tmp
tar -xf /pkgs/bison-3.8.2.tar.xz    \
    -C /build/bison-tmp --strip-components 1

pushd /build/bison-tmp

./configure         \
    --prefix=/usr   \
    --docdir=/usr/share/doc/bison-3.8.2

make
make install

popd


# perl
mkdir -pv /build/perl-tmp
tar -xf /pkgs/perl-5.36.0.tar.xz    \
    -C /build/perl-tmp --strip-components 1

pushd /build/perl-tmp

sh ./Configure                                  \
    -des                                        \
    -Dprefix=/usr                               \
    -Dvendorprefix=/usr                         \
    -Dprivlib=/usr/lib/perl5/5.36/core_perl     \
    -Darchlib=/usr/lib/perl5/5.36/core_perl     \
    -Dsitelib=/usr/lib/perl5/5.36/site_perl     \
    -Dsitearch=/usr/lib/perl5/5.36/site_perl    \
    -Dvendorlib=/usr/lib/perl5/5.36/vendor_perl \
    -Dvendorarch=/usr/lib/perl5/5.36/vendor_perl

make
make install

popd


# python-3.10.6
mkdir -pv /build/python3.10-tmp
tar -xf /pkgs/Python-3.10.6.tar.xz      \
    -C /build/python3.10-tmp --strip-components 1

pushd /build/python3.10-tmp

./configure                 \
    --prefix=/usr           \
    --enable-shared         \
    --without-ensurepip

make
make install

popd


# texinfo
mkdir -pv /build/texinfo-tmp
tar -xf /pkgs/texinfo-6.8.tar.xz -C /build/texinfo-tmp --strip-components 1

pushd /build/texinfo-tmp

./configure --prefix=/usr

make
make install

pushd


# util linux
mkdir -pv /var/lib/hwclock
mkdir -pv /build/util-linux-tmp
tar -xf /pkgs/util-linux-2.38.1.tar.xz  \
    -C /build/util-linux-tmp --strip-components 1

pushd /build/util-linux-tmp

./configure                                     \
    ADJTIME_PATH=/var/lib/hwclock/adjtime       \
    --libdir=/usr/lib                           \
    --docdir=/usr/share/doc/util-linux-2.38.1   \
    --disable-chfn-chsh                         \
    --disable-login                             \
    --disable-nologin                           \
    --disable-su                                \
    --disable-setpriv                           \
    --disable-runuser                           \
    --disable-pylibmount                        \
    --disable-static                            \
    --without-python                            \
    runstatedir=/run

make
make install

popd


# clean up
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
# rm -rf /build/*
