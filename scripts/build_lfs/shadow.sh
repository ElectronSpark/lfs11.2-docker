#!/bin/bash

mkdir -pv /build/shadow
tar -xf /pkgs/shadow-4.12.2.tar.xz      \
    -C /build/shadow --strip-components 1

pushd /build/shadow

# disable the installation of the groups program and its man page, as Coreutils 
# provides a better version. Also, prevent the installation of mannual pages 
# that were already installed in section 8.3
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

touch /usr/bin/passwd
./configure                         \
    --sysconfdir=/etc               \
    --disable-static                \
    --with-group-name-max-length=32

make
make exec_prefix=/usr install
make -C man install-man

popd


# configure shadow

# enable shadowed passwords
pwconv
# enable shadowed group passwords
grpconv

# create /etc/default/useradd in order to change the default parameters of
# shadows.
mkdir -p /etc/default
useradd -D --gid 999

# root's password need to be typed manually.
# @TODO: somethong wrong happened there.
passwd root
