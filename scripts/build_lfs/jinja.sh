#!/bin/bash

mkdir -pv /build/jinja2
tar -xf /pkgs/Jinja2-3.1.2.tar.gz           \
    -C /build/jinja2 --strip-components 1

pushd /build/jinja2

# compile Jinja
pip3 wheel -w dist --no-build-isolation --no-deps $PWD

# install it
pip3 install --no-index --no-user --find-links dist Jinja2

popd
