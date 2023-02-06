#!/bin/bash

mkdir -pv /{build,sources}/gettext
tar -xf /pkgs/gettext-0.21.tar.xz           \
    -C /sources/gettext --strip-components 1

pushd /build/gettext

/sources/gettext/configure          \
    --prefix=/usr                   \
    --disable-static                \
    --docdir=/usr/share/doc/gettext-0.21

make
make check > test_result.log
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

popd
