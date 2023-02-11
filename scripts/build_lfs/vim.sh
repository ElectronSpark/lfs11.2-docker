#!/bin/bash

mkdir -pv /build/vim
tar -xf /pkgs/vim-9.0.0228.tar.gz       \
    -C /build/vim --strip-components 1

pushd /build/vim

# change the default location of the vimrc configuration file to /etc
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make

chown -Rv tester .
su tester -c "LANG=en_US.UTF-8 make -j1 test" &> vim-test.log

make install

# link command vi to vim
ln -sv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

# allows the documentation to be accessed via /usr/share/doc/vim-9.0.0228
ln -sv ../vim/vim90/doc /usr/share/doc/vim-9.0.0228

popd
