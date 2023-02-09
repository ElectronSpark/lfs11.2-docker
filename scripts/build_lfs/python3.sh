#!/bin/bash

mkdir -pv /{build,sources}/python3.10
tar -xf /pkgs/Python-3.10.6.tar.xz                  \
    -C /sources/python3.10 --strip-components 1

pushd /build/python3.10

/sources/python3.10/configure   \
    --prefix=/usr               \
    --enable-shared             \
    --with-system-expat         \
    --with-system-ffi           \
    --enable-optimizations

make

make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

popd
