#!/bin/bash

mkdir -pv /build/intltool
tar -xf /pkgs/intltool-0.51.0.tar.gz        \
    -C /build/intltool --strip-components 1
pushd /build/intltool

# fix a warning that is caused by perl-5.22 and later
sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make
make check > test_result.log

make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

popd
