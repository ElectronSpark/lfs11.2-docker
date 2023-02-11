#!/bin/bash

mkdir -pv /build/e2fsprogs
tar -xf /pkgs/e2fsprogs-1.46.5.tar.gz   \
    -C /build/e2fsprogs --strip-components 1

pushd /build/e2fsprogs

mkdir -v build
cd build

../configure                \
    --prefix=/usr           \
    --sysconfdir=/etc       \
    --enable-elf-shlibs     \
    --disable-libblkid      \
    --disable-libuuid       \
    --disable-uuidd         \
    --disable-fsck

make

make check > test_result.log

make install

# remove useless static libraries
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

# update the system dir file
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

# create and install some additional documentation
makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

popd
