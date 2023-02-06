#!/bin/bash

mkdir -pv /build/libcap
tar -xf /pkgs/libcap-2.65.tar.xz          \
    -C /build/libcap --strip-components 1

pushd /build/libcap

# prevent static libraries from being installed.
sed -i '/install -m.*STA/d' libcap/Makefile
make prefix=/usr lib=lib
make test > test_result.sh
make prefix=/usr lib=lib install

popd
