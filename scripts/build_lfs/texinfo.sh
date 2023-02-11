#!/bin/bash

mkdir -pv /build/texinfo
tar -xf /pkgs/texinfo-6.8.tar.xz        \
    -C /build/texinfo --strip-components 1

pushd /build/texinfo

./configure --prefix=/usr

make

make check > test_result.log

make install

# install the components belonging in a TeX installation.
make TEXMF=/usr/share/texmf install-tex

# makefile of various packages can sometimes get out of sync
pushd /usr/share/info
    rm -v dir
    for f in *
        do install-info $f dir 2>/dev/null
    done
popd

popd
