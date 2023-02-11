#!/bin/bash

mkdir -pv /build/systemd
tar -xf /pkgs/systemd-251.tar.gz        \
    -C /build/systemd --strip-components 1

pushd /build/systemd

# fix some problems introduced by glibc-2.36
patch -Np1 -i /pkgs/systemd-251-glibc_2.36_fix-1.patch

# remove two uneeded groups, render and sgx, from the default udev rules
sed -i -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

mkdir -p build
cd  build

meson   --prefix=/usr                       \
        --buildtype=release                 \
        -Ddefault-dnssec=no                 \
        -Dfirstboot=false                   \
        -Dinstall-tests=false               \
        -Dldconfig=false                    \
        -Dsysusers=false                    \
        -Drpmmacrosdir=no                   \
        -Dhomed=false                       \
        -Duserdb=false                      \
        -Dman=false                         \
        -Dmode=release                      \
        -Dpamconfdir=no                     \
        -Ddocdir=/usr/share/doc/systemd-251 \
        ..

ninja

ninja install

# install man pages
tar -xf /pkgs/systemd-man-pages-251.tar.xz --strip-components=1 -C /usr/share/man

# create the /etc/machine-id file needed by systemd-journald
systemd-machine-id-setup
# setup the basic target structure
systemctl preset-all
# disable a service for upgrading binary distros.
systemctl disable systemd-sysupdate

popd
