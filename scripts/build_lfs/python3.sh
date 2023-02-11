#!/bin/bash

mkdir -pv /build/python3.10
tar -xf /pkgs/Python-3.10.6.tar.xz                  \
    -C /build/python3.10 --strip-components 1

pushd /build/python3.10

./configure                     \
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

# install the preformatted documentation
# --no-same-owner and --no-same-permissions ensure the installed files have
# the correct ownership and permissions.
install -v -dm755 /usr/share/doc/python-3.10.6/html
tar --strip-components=1                        \
    --no-same-owner                             \
    --no-same-permissions                       \
    -C /usr/share/doc/python-3.10.6/html        \
    -xvf /pkgs/python-3.10.6-docs-html.tar.bz2

popd
