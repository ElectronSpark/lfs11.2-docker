#!/bin/bash

mkdir -pv /{sources,build}/file
tar -xf /pkgs/file-5.42.tar.gz                  \
    -C /sources/file --strip-components 1

pushd /build/file

/sources/file/configure --prefix=/usr

make
make check > test_result.log
make install

popd
