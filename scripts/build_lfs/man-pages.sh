#!/bin/bash

mkdir -pv /build/man-pages
tar -xf /pkgs/man-pages-5.13.tar.xz \
    -C /build/man-pages --strip-components 1

pushd /build/man-pages

make prefix=/usr install

popd
