#!/bin/bash

mkdir -pv /build/wheel
tar -xf /pkgs/wheel-0.37.1.tar.gz           \
    -C /build/wheel --strip-components 1

pushd /build/wheel

pip3 install --no-index $PWD

popd
