#!/bin/bash

mkdir -pv /{build,sources}/gperf
tar -xf /pkgs/gperf-3.1.tar.gz              \
    -C /sources/gperf --strip-components 1

pushd /build/gperf

/sources/gperf/configure    \
    --prefix=/usr           \
    --docdir=/usr/share/doc/gperf-3.1

make
make -j1 check > test_result.log
make install

popd
