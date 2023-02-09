#!/bin/bash

mkdir -pv /build/coreutils
tar -xf /pkgs/coreutils-9.1.tar.xz          \
    -C /build/coreutils --strip-components 1

pushd /build/coreutils
patch -Np1 -i /pkgs/coreutils-9.1-i18n-1.patch

# prepare corutils for compilation
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure        \
    --prefix=/usr                           \
    --enable-no-install-program=kill,uptime

make

# run test suite
make NON_ROOT_USERNAME=tester check-root
echo "dummy:x:102:tester" >> /etc/group
chown -Rv tester .
su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
sed -i '/dummy/d' /etc/group

# install the package
make install
# move programs to the locations specified by the FHS
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

popd
