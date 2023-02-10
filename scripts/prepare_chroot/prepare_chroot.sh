#!/bin/bash
# This program builds and installs a set of imcomplete cross toolchains, wich
# will be installed under the ${LFS}/tools directory and be used to build our 
# final cross toolchains, before entering chroot environment.


# binutils (pass 1)
mkdir -pv ${LFS_HOME}/build/binutils
tar -xf ${LFS}/pkgs/binutils-2.39.tar.xz   \
    -C ${LFS_HOME}/build/binutils --strip-components 1
pushd ${LFS_HOME}/build/binutils

mkdir -v build
cd build
# build binutils and install it into /tools with ${LFS} as its sysroot
../configure                            \
    --prefix=${LFS}/tools               \
    --with-sysroot=${LFS}               \
    --target=${LFS_TGT}                 \
    --disable-nls                       \
    --enable-gprofng=no                 \
    --disable-werror

make
make install

popd


# gcc (pass 1 without glibc)
mkdir -pv ${LFS_HOME}/build/gcc
tar -xf ${LFS}/pkgs/gcc-12.2.0.tar.xz  \
    -C ${LFS_HOME}/build/gcc --strip-components 1
pushd ${LFS_HOME}/build/gcc

# unpack packages required by gcc to gcc's source directory
tar -xf ${LFS}/pkgs/gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ${LFS}/pkgs/mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc
tar -xf ${LFS}/pkgs/mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr

# set the default directory name for 64-bit libraries to "lib"
sed -e "/m64=/s/lib64/lib/" -i.orig gcc/config/i386/t-linux64

mkdir -v build
cd build

# this gcc will be used to compile packages running in the chroot envitonment
../configure                            \
    --prefix=${LFS}/tools               \
    --with-sysroot=${LFS}               \
    --target=${LFS_TGT}                 \
    --disable-nls                       \
    --disable-shared                    \
    --disable-multilib                  \
    --disable-decimal-float             \
    --disable-threads                   \
    --disable-libatomic                 \
    --disable-libgomp                   \
    --disable-libquadmath               \
    --disable-libssp                    \
    --disable-libvtv                    \
    --disable-libstdcxx                 \
    --with-glibc-version=2.36           \
    --with-newlib                       \
    --without-headers                   \
    --enable-languages=c,c++

make
make install

# create a full version of the internal header using a command that is
# identical to what the GCC build system does in normal circumstances.
cat ../gcc/limitx.h ../gcc/glimits.h ../gcc/limity.h >  \
    `dirname $(${LFS_TGT}-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

popd


# install linux API headers
# linux kernel will be build at top directory of linux's source code, so just
# extract kernel source code into ${LFS_HOME}/build/linux-5.19.2
tar -xf ${LFS}/pkgs/linux-5.19.2.tar.xz -C ${LFS_HOME}/build

pushd ${LFS_HOME}/build/linux-5.19.2

# make sure there're no stale files embedded in the package
make mrproper
# extract the user-visible kernel headers from the source.
make headers
# delete all files other than .h files?
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include ${LFS}/usr

popd

 
# glibc (pass 1)
tar -xf ${LFS}/pkgs/glibc-2.36.tar.xz -C ${LFS_HOME}/build
pushd ${LFS_HOME}/build/glibc-2.36

# create a symbolic link for LSB compliance first. My machine is x86_64, and I
# only consider what works for my machine.
ln -sfv ../lib/ld-linux-x86-64.so.2 ${LFS}/lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 ${LFS}/lib64/ld-lsb-x86-64.so.3
# apply the following patch to make glibc programs store their runtime data in
# the FHS-compliant locations.
patch -Np1 -i ${LFS}/pkgs/glibc-2.36-fhs-1.patch

mkdir -v build
cd build

# make sure that ldconfig and sln utilities are installed into /usr/bin
echo "rootsbindir=/usr/sbin" > configparms
# glibc at this stage will be cross-compiled by the cross-toolchain just built.
../configure                                \
    --prefix=/usr                           \
    --host=${LFS_TGT}                       \
    --build=$(../scripts/config.guess)      \
    --enable-kernel=3.2                     \
    --with-headers=${LFS}/usr/include       \
    libc_cv_slibdir=/usr/lib
# build glibc and install it at ${LFS}
make
make DESTDIR=${LFS} install

# fix hardcored path to the executable loader in ldd script
sed '/RTLDLIST=/s@/usr@@g' -i ${LFS}/usr/bin/ldd

# @TODO: It will be better to perform a sanity check.
echo 'int main(){}' | gcc -xc -
readelf -l a.out | grep ld-linux
rm -v a.out

# finalize the installation of the limits.h header
${LFS}/tools/libexec/gcc/${LFS_TGT}/12.2.0/install-tools/mkheaders

popd


# libstdc++
# It's the standard C++ library, which is needed to compile C++ code including
# part of GCC.
# Because libstdc++ is a part of gcc, there's no need to extract a package.
pushd ${LFS_HOME}/build/gcc

mkdir -v build_libstdc++-v3
cd build_libstdc++-v3

../libstdc++-v3/configure               \
    --host=${LFS_TGT}                   \
    --build=$(../config.guess)      \
    --prefix=/usr                       \
    --disable-nls                       \
    --disable-multilib                  \
    --disable-libstdcxx-pch             \
    --with-gxx-include-dir=/tools/${LFS_TGT}/include/c++/12.2.0

make
make DESTDIR=${LFS} install

# These libtool archives are harmful for cross compilation
rm -v ${LFS}/usr/lib/lib{stdc++,stdc++fs,supc++}.la

popd


# We've completed building cross-toolchain (pass1). The next step is to use
# this toolchain to compile basic utilities and install them into their final
# location. These basic utilities will be used after entering the chroot 
# environment.


# m4
mkdir -pv ${LFS_HOME}/build/m4
tar xf ${LFS}/pkgs/m4-1.4.19.tar.xz         \
    -C ${LFS_HOME}/build/m4                 \
    --strip-components 1

pushd ${LFS_HOME}/build/m4

./configure                        \
    --prefix=/usr                   \
    --host=${LFS_TGT}               \
    --build=$(build-aux/config.guess)

make
make DESTDIR=${LFS} install

popd


# ncurses
mkdir -pv ${LFS_HOME}/build/ncurses
tar -xf ${LFS}/pkgs/ncurses-6.3.tar.gz          \
    -C ${LFS_HOME}/build/ncurses                \
    --strip-components 1

pushd ${LFS_HOME}/build/ncurses

# make sure that gawk is found first during configuration.
sed -i s/mawk// configure
# build "tic" program on the build host. This can run on the building machine,
# and it is needed to create the terminal database without error during
# ncurses' installation.
mkdir -pv build
pushd build
    ../configure
    make -C include
    make -C progs tic
popd

# configure ncurses for compilation
./configure                         \
    --prefix=/usr                   \
    --host=${LFS_TGT}               \
    --build=$(./config.guess)       \
    --mandir=/usr/share/man         \
    --with-manpage-format=normal    \
    --with-shared                   \
    --without-normal                \
    --with-cxx-shared               \
    --without-debug                 \
    --without-ada                   \
    --disable-stripping             \
    --enable-widec

make
make DESTDIR=${LFS} TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > ${LFS}/usr/lib/libncurses.so
popd


# bash
mkdir -pv ${LFS_HOME}/build/bash
tar -xf ${LFS}/pkgs/bash-5.1.16.tar.gz  \
    -C ${LFS_HOME}/build/bash           \
    --strip-components 1

pushd ${LFS_HOME}/build/bash
# bash's memory allocation function may cause segmentation faults
./configure                             \
    --prefix=/usr                       \
    --host=${LFS_TGT}                   \
    --build=$(support/config.guess)     \
    --without-bash-malloc

make
make DESTDIR=${LFS} install

# make the bash just built as the default shell
ln -sv bash ${LFS}/bin/sh
popd


# coreutils
mkdir -pv ${LFS_HOME}/build/coreutils
tar -xf ${LFS}/pkgs/coreutils-9.1.tar.xz    \
    -C ${LFS_HOME}/build/coreutils          \
    --strip-components 1

pushd ${LFS_HOME}/build/coreutils

./configure                                     \
    --prefix=/usr                               \
    --host=${LFS_TGT}                           \
    --build=$(build-aux/config.guess)           \
    --enable-install-program=hostname           \
    --enable-no-install-program=kill,uptime

make
make DESTDIR=${LFS} install

mv -v ${LFS}/usr/bin/chroot                 ${LFS}/usr/sbin
mkdir -pv ${LFS}/usr/share/man/man8
mv -v ${LFS}/usr/share/man/man1/chroot.1    ${LFS}/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                         ${LFS}/usr/share/man/man8/chroot.8

popd


# diffutils
mkdir -pv ${LFS_HOME}/build/diffutils
tar -xf ${LFS}/pkgs/diffutils-3.8.tar.xz            \
    -C ${LFS_HOME}/build/diffutils                \
    --strip-components 1

pushd ${LFS_HOME}/build/diffutils

./configure --prefix=/usr --host=${LFS_TGT}

make 
make DESTDIR=${LFS} install

popd


# file
mkdir -pv ${LFS_HOME}/build/file/{,build}
tar -xf ${LFS}/pkgs/file-5.42.tar.gz            \
    -C ${LFS_HOME}/build/file                   \
    --strip-components 1

pushd ${LFS_HOME}/build/file

# the file command on the build machine needs to be same version as the one 
# to be built.
pushd build
    ../configure                \
        --disable-bzlib         \
        --disable-libseccomp    \
        --disable-xzlib         \
        --disable-zlib
    make
popd

# build the file command on target machine
./configure                      \
    --prefix=/usr                                       \
    --host=${LFS_TGT}                                   \
    --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=${LFS} install
# remove harmful libtool archive file
rm -v ${LFS}/usr/lib/libmagic.la

popd


# findutils
mkdir -pv ${LFS_HOME}/build/findutils
tar -xf ${LFS}/pkgs/findutils-4.9.0.tar.xz      \
    -C ${LFS_HOME}/build/findutils              \
    --strip-components 1

pushd ${LFS_HOME}/build/findutils

./configure                             \
    --prefix=/usr                       \
    --host=${LFS_TGT}                   \
    --build=$(build-aux/config.guess)   \
    --localstatedir=/var/lib/locate

make
make DESTDIR=${LFS} install

popd


# gawk
mkdir -pv ${LFS_HOME}/build/gawk
tar -xf ${LFS}/pkgs/gawk-5.1.1.tar.xz           \
    -C ${LFS_HOME}/build/gawk                   \
    --strip-components 1

pushd ${LFS_HOME}/build/gawk

# ensure some uneeded files are not installed.
sed -i 's/extras//' Makefile.in

./configure                             \
    --prefix=/usr                       \
    --host=${LFS_TGT}                   \
    --build=$(build-aux/config.guess)

make
make DESTDIR=${LFS} install

popd


# grep
mkdir -pv ${LFS_HOME}/build/grep
tar -xf ${LFS}/pkgs/grep-3.7.tar.xz         \
    -C ${LFS_HOME}/build/grep             \
    --strip-components 1

pushd ${LFS_HOME}/build/grep

./configure             \
    --prefix=/usr       \
    --host=${LFS_TGT}

make
make DESTDIR=${LFS} install

popd


# gzip
mkdir -pv ${LFS_HOME}/build/gzip
tar -xf ${LFS}/pkgs/gzip-1.12.tar.xz    \
    -C ${LFS_HOME}/build/gzip           \
    --strip-components 1

pushd ${LFS_HOME}/build/gzip

./configure             \
    --prefix=/usr       \
    --host=${LFS_TGT}

make
make DESTDIR=${LFS} install

popd


# make
mkdir -pv ${LFS_HOME}/build/make
tar -xf ${LFS}/pkgs/make-4.3.tar.gz         \
    -C ${LFS_HOME}/build/make               \
    --strip-components 1

pushd ${LFS_HOME}/build/make
# adding option "--without-guile" is to prevent configure from using guile
# from the building machine, which makes compilation fail.
./configure                             \
    --prefix=/usr                       \
    --host=${LFS_TGT}                   \
    --without-guile                     \
    --build=$(build-aux/config.guess)

make
make DESTDIR=${LFS} install

popd


# patch
mkdir -pv ${LFS_HOME}/build/patch
tar -xf ${LFS}/pkgs/patch-2.7.6.tar.xz          \
    -C ${LFS_HOME}/build/patch                  \
    --strip-components 1

pushd ${LFS_HOME}/build/patch

./configure                             \
    --prefix=/usr                       \
    --host=${LFS_TGT}                   \
    --build=$(build-aux/config.guess)

make
make DESTDIR=${LFS} install

popd


# sed
mkdir -pv ${LFS_HOME}/build/sed
tar -xf ${LFS}/pkgs/sed-4.8.tar.xz      \
    -C ${LFS_HOME}/build/sed            \
    --strip-components 1

pushd ${LFS_HOME}/build/sed

./configure                 \
    --prefix=/usr           \
    --host=${LFS_TGT}                                           

make
make DESTDIR=${LFS} install

popd


# tar
mkdir -pv ${LFS_HOME}/build/tar
tar -xf ${LFS}/pkgs/tar-1.34.tar.xz     \
    -C ${LFS_HOME}/build/tar            \
    --strip-components 1

pushd ${LFS_HOME}/build/tar

./configure                             \
    --prefix=/usr                       \
    --host=${LFS_TGT}                   \
    --build=$(build-aux/config.guess)

make
make DESTDIR=${LFS} install

popd


# xz
mkdir -pv ${LFS_HOME}/build/xz
tar -xf ${LFS}/pkgs/xz-5.2.6.tar.xz     \
    -C ${LFS_HOME}/build/xz             \
    --strip-components 1

pushd ${LFS_HOME}/build/xz

./configure                                 \
    --prefix=/usr                           \
    --host=${LFS_TGT}                       \
    --build=$(build-aux/config.guess)       \
    --disable-static                        \
    --docdir=/usr/share/doc/xz-5.2.6

make
make DESTDIR=${LFS} install
# remove harmful libtool archive file
rm -v ${LFS}/usr/lib/liblzma.la

popd


# binutils (pass 2)
# we've already unpacked binutils' pack, so we only need to create another
# temporary path for building.
mkdir -pv ${LFS_HOME}/build/binutils_p2
tar -xf ${LFS}/pkgs/binutils-2.39.tar.xz   \
    -C ${LFS_HOME}/build/binutils_p2 --strip-components 1

# build the file command on target machine
pushd ${LFS_HOME}/build/binutils_p2

sed '6009s/$add_dir//' -i ltmain.sh

mkdir -v build
cd build

../configure                        \
    --prefix=/usr                   \
    --host=${LFS_TGT}               \
    --build=$(../config.guess)      \
    --disable-nls                   \
    --enable-shared                 \
    --enable-gprofng=no             \
    --disable-werror                \
    --enable-64-bit-bfd

make
make DESTDIR=${LFS} install
# remove harmful libtool archive file
rm -v ${LFS}/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}

popd


# gcc (pass 2)
mkdir -pv ${LFS_HOME}/build/gcc_p2
tar -xf ${LFS}/pkgs/gcc-12.2.0.tar.xz  \
    -C ${LFS_HOME}/build/gcc_p2 --strip-components 1
pushd ${LFS_HOME}/build/gcc_p2

# unpack packages required by gcc to gcc's source directory
tar -xf ${LFS}/pkgs/gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ${LFS}/pkgs/mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc
tar -xf ${LFS}/pkgs/mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr

# set the default directory name for 64-bit libraries to "lib"
sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

# override the building rule of libgcc and libstdc++ headers, to allow building
# these libraries with POSIX threads support.
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build
cd build

../configure                            \
    --build=$(../config.guess)          \
    --host=$LFS_TGT                     \
    --target=$LFS_TGT                   \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc   \
    --prefix=/usr                       \
    --with-build-sysroot=$LFS           \
    --enable-initfini-array             \
    --disable-nls                       \
    --disable-multilib                  \
    --disable-decimal-float             \
    --disable-libatomic                 \
    --disable-libgomp                   \
    --disable-libquadmath               \
    --disable-libssp                    \
    --disable-libvtv                    \
    --enable-languages=c,c++

make
make DESTDIR=${LFS} install

# make all programs and scripts run gcc
ln -sv gcc ${LFS}/usr/bin/cc

popd


# clean up all the temporary files generated while compiling.
# rm -rf ${LFS_HOME}/build/
