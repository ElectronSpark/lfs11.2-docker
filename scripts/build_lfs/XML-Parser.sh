#!/bin/bash

mkdir -pv /build/XML-Parser
tar -xf /pkgs/XML-Parser-2.46.tar.gz                \
    -C /build/XML-Parser --strip-components 1

pushd /build/XML-Parser

perl Makefile.PL

make
make test > test_result.log
make install

popd
