#!/bin/bash
# This program builds and installs a set of imcomplete cross toolchains, wich
# will be installed under the ${LFS}/tools directory and be used to build our 
# final cross toolchains, before entering chroot environment.


# binutils (pass 1)
mkdir -pv ${LFS_HOME}/{build,sources}/binutils
tar -xf ${LFS_HOME}/sources/binutils-2.39.tar.xz   \
    -C ${LFS_HOME}/sources/binutils --strip-components 1
pushd ${LFS_HOME}/build/binutils

# build binutils and install it into /tools with ${LFS} as its sysroot
${LFS_HOME}/sources/binutils/configure  \
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
mkdir -pv ${LFS_HOME}/{build,sources}/gcc
tar -xf ${LFS_HOME}/sources/gcc-12.2.0.tar.xz  \
    -C ${LFS_HOME}/sources/gcc --strip-components 1
# unpack packages required by gcc to gcc's source directory
mkdir -pv ${LFS_HOME}/sources/gcc/{gmp,mpc,mpfr}
tar -xf ${LFS_HOME}/sources/gmp-6.2.1.tar.xz \
    -C ${LFS_HOME}/sources/gcc/gmp --strip-components 1
tar -xf ${LFS_HOME}/sources/mpc-1.2.1.tar.gz \
    -C ${LFS_HOME}/sources/gcc/mpc --strip-components 1
tar -xf ${LFS_HOME}/sources/mpfr-4.1.0.tar.xz \
    -C ${LFS_HOME}/sources/gcc/mpfr --strip-components 1

# set the default directory name for 64-bit libraries to "lib"
sed -e "/m64=/s/lib64/lib/" \
    -i.orig ${LFS_HOME}/sources/gcc/gcc/config/i386/t-linux64

pushd ${LFS_HOME}/build/gcc

# this gcc will be used to compile packages running in the chroot envitonment
${LFS_HOME}/sources/gcc/configure       \
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
cat ${LFS_HOME}/sources/gcc/gcc/limitx.h    \
    ${LFS_HOME}/sources/gcc/gcc/glimits.h   \
    ${LFS_HOME}/sources/gcc/gcc/limity.h >  \
    `dirname $(${LFS_TGT}-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

popd


# install linux API headers
# linux kernel will be build at top directory of linux's source code, so just
# extract kernel source code into ${LFS_HOME}/build/linux-5.19.2
tar -xf ${LFS_HOME}/sources/linux-5.19.2.tar.xz -C ${LFS_HOME}/build

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
# create a symbolic link for LSB compliance first. My machine is x86_64, and I
# only consider what works for my machine.
ln -sfv ../lib/ld-linux-x86-64.so.2 ${LFS}/lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 ${LFS}/lib64/ld-lsb-x86-64.so.3
tar -xf ${LFS_HOME}/sources/glibc-2.36.tar.xz -C ${LFS_HOME}/sources
# apply the following patch to make glibc programs store their runtime data in
# the FHS-compliant locations.
pushd ${LFS_HOME}/sources/glibc-2.36
patch -Np1 -i ../glibc-2.36-fhs-1.patch
popd

mkdir -pv ${LFS_HOME}/build/glibc-2.36
pushd ${LFS_HOME}/build/glibc-2.36

# make sure that ldconfig and sln utilities are installed into /usr/bin
echo "rootsbindir=/usr/sbin" > configparms
# glibc at this stage will be cross-compiled by the cross-toolchain just built.
${LFS_HOME}/sources/glibc-2.36/configure    \
    --prefix=/usr                           \
    --host=${LFS_TGT}                       \
    --build=$(${LFS_HOME}/sources/glibc-2.36/scripts/config.guess)  \
    --enable-kernel=3.2                     \
    --with-headers=${LFS}/usr/include       \
    libc_cv_slibdir=/usr/lib
# build glibc and install it at ${LFS}
make
make DESTDIR=${LFS} install

# fix hardcored path to the executable loader in ldd script
sed "/RTLDLIST=/s@/usr@@g" -i ${LFS}/usr/bin/ldd

# @TODO: It will be better to perform a sanity check.

# finalize the installation of the limits.h header
${LFS}/tools/libexec/gcc/${LFS_TGT}/12.2.0/install-tools/mkheaders

popd


# libstdc++
# It's the standard C++ library, which is needed to compile C++ code including
# part of GCC.
# Because libstdc++ is a part of gcc, there's no need to extract a package.
mkdir -pv ${LFS_HOME}/build/libstdc++-v3
pushd ${LFS_HOME}/build/libstdc++-v3

${LFS_HOME}/sources/gcc/libstdc++-v3/configure  \
    --host=${LFS_TGT}                           \
    --build=$(${LFS_HOME}/sources/gcc/config.guess) \
    --prefix=/usr                               \
    --disable-nls                       \
    --disable-multilib                  \
    --disable-libstdcxx-pch             \
    --with-gxx-include-dir=/tools/${LFS_TGT}/include/c++/12.2.0

make
make DESTDIR=${LFS} install

# These libtool archives are harmful for cross compilation
rm -v ${LFS}/usr/lib/lib{stdc++,stdc++fs,supc++}.la

popd

