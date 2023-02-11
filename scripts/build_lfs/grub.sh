#!/bin/bash

mkdir -pv /build/grub
tar -xf /pkgs/grub-2.06.tar.xz              \
    -C /build/grub --strip-components 1

pushd /build/grub

# '--disable-efiemu' this is not needed for LFS
./configure                 \
    --prefix=/usr           \
    --sysconfdir=/etc       \
    --disable-efiemu        \
    --disable-werror

make

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

popd
