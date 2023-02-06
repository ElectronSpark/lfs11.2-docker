#!/bin/bash

# this test is better to be done before running the test suites for binutils
# and gcc.
# expect -c "spawn ls"

mkdir -pv /{build,sources}/gcc
tar -xf /pkgs/gcc-12.2.0.tar.xz                 \
    -C /sources/gcc --strip-components 1

# this line is specific to x86_64 machine
sed -e '/m64=/s/lib64/lib/' \
    -i.orig /sources/gcc/gcc/config/i386/t-linux64

pushd /build/gcc

/sources/gcc/configure                  \
    --prefix=/usr                       \
    LD=ld                               \
    --enable-languages=c,c++            \
    --disable-multilib                  \
    --disable-bootstrap                 \
    --with-system-zlib

make

# increase stack size prior to running gcc's tests
ulimit -s 32768
# test the results as a non-privileged user
groupadd tester
useradd -s /bin/bash -g tester -m -k /dev/null tester
chown -Rv tester .
su tester -c "PATH=$PATH make -k check"
# to receive a summary of the test results
/sources/gcc/contrib/test_summary

# install the package
make install
# change the ownership of gcc back to root
chown -v -R root:root   \
    /usr/lib/gcc/$(gcc -dumpmachine)/12.2.0/include{,-fixed}

ln -svr /usr/bin/cpp /usr/lib

# add a compatibility symlink to enable building programs with Linik Time
# Optimization.
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/12.2.0/liblto_plugin.so \
    /usr/lib/bfd-plugins/

# do sanity check, the output should be:
#   [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

# make sure that we are set up to use the correct start files,
# the output should be:
#   /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/../../../../lib/crt1.o succeeded
#   /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/../../../../lib/crti.o succeeded
#   /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/../../../../lib/crtn.o succeeded
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

# make sure that the compiler is searching for the correct header files,
# the output should be:
#   #include <...> search starts here:
#    /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/include
#    /usr/local/include
#    /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/include-fixed
#    /usr/include
grep -B4 '^ /usr/include' dummy.log

# make sure the new linker is being used with the correct search paths,
# the output should be:
#   SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
#   SEARCH_DIR("/usr/local/lib64")
#   SEARCH_DIR("/lib64")
#   SEARCH_DIR("/usr/lib64")
#   SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
#   SEARCH_DIR("/usr/local/lib")
#   SEARCH_DIR("/lib")
#   SEARCH_DIR("/usr/lib");
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

# make sure that we are using the correct libc
# the output should be:
#   attempt to open /usr/lib/libc.so.6 succeeded
grep "/lib.*/libc.so.6 " dummy.log

# make sure gcc is using the correct dynamic linker, the output should be:
#   found ld-linux-x86-64.so.2 at /usr/lib/ld-linux-x86-64.so.2
grep found dummy.log

# cleanup
rm -v dummy.c a.out dummy.log

# move a misplaced file
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

popd
