#!/bin/bash

mkdir -pv /{build,sources}/intltool
tar -xf /pkgs/intltool-0.51.0.tar.gz        \
    -C /sources/intltool --strip-components 1

# fix a warning that is caused by perl-5.22 and later
sed -i 's:\\\${:\\\$\\{:' /sources/intltool/intltool-update.in

pushd /build/intltool

/sources/intltool/configure --prefix=/usr

make
make check > test_result.log
make install

install -v -Dm644 /sources/intltool/doc/I18N-HOWTO  \
    /usr/share/doc/intltool-0.51.0/I18N-HOWTO

popd
