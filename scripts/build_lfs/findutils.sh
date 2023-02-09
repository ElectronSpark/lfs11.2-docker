#!/bin/bash

mkdir -pv /{build,sources}/findutils
tar -xf /pkgs/findutils-4.9.0.tar.xz            \
    -C /sources/findutils --strip-components 1

pushd /build/findutils

# if it's building a 32bit system, 'TIME_32_BIT_OK=yes' is needed to be added.
/sources/findutils/configure --prefix=/usr --localstatedir=/var/lib/locate

make

# do test
chown -Rv tester .
su tester -c "PATH=$PATH make check"

# install the package
make install

popd
