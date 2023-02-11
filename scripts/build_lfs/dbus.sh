#!/bin/bash

mkdir -pv /build/dbus
tar -xf /pkgs/dbus-1.14.0.tar.xz        \
    -C /build/dbus --strip-components 1

pushd /build/dbus

./configure                                         \
    --prefix=/usr                                   \
    --sysconfdir=/etc                               \
    --localstatedir=/var                            \
    --runstatedir=/run                              \
    --disable-static                                \
    --disable-doxygen-docs                          \
    --disable-xml-docs                              \
    --docdir=/usr/share/doc/dbus-1.14.0             \
    --with-system-socket=/run/dbus/system_bus_socket

make

make install

ln -sfv /etc/machine-id /var/lib/dbus

popd
