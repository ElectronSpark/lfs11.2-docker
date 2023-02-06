#!/bin/bash

mkdir -pv /build/zstd
tar -xf /pkgs/zstd-1.5.2.tar.gz                 \
    -C /build/zstd --strip-components 1

pushd /build/zstd

patch -Np1 -i /pkgs/zstd-1.5.2-upstream_fixes-1.patch

make prefix=/usr
make check > test_result.log
make prefix=/usr install

# remove useless static library
rm -fv /usr/lib/libzstd.a

popd
