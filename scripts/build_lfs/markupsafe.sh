#!/bin/bash

mkdir -pv /build/markupsafe
tar -xf /pkgs/MarkupSafe-2.1.1.tar.gz       \
    -C /build/markupsafe --strip-components 1

pushd /build/markupsafe

# compile MarkupSafe
pip3 wheel -w dist --no-build-isolation --no-deps $PWD

# install it
pip3 install --no-index --no-user --find-links dist Markupsafe

popd
