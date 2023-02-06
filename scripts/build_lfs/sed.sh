#!/bin/bash

mkdir -pv /{build,sources}/sed
tar -xf /pkgs/sed-4.8.tar.xz                \
    -C /sources/sed --strip-components 1

pushd /build/sed

/sources/sed/configure --prefix=/usr

# compile the package and generate its HTML documentation
make
make html

# test the results as a unprivileged user.
chown -Rv tester .
su tester -c "PATH=$PATH make check"

# install the package and its documentation
make install
install -d -m755    /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

popd
