#!/bin/bash

mkdir -pv /{build,sources}/grub
tar -xf /pkgs/grub-2.06.tar.xz              \
    -C /sources/grub --strip-components 1

pushd /build/grub

# '--disable-efiemu' this is not needed for LFS
/sources/grub/configure     \
    --prefix=/usr           \
    --sysconfdir=/etc       \
    --disable-efiemu        \
    --disable-werror

make

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

popd
