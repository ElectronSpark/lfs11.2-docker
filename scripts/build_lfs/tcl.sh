#!/bin/bash

mkdir -pv /build/tcl
tar -xf /pkgs/tcl8.6.12-src.tar.gz          \
    -C /build/tcl --strip-components 1

pushd /build/tcl

tar -xf /pkgs/tcl8.6.12-html.tar.gz --strip-components 1

SRCDIR=$(pwd)
cd unix
./configure                 \
    --prefix=/usr           \
    --mandir=/usr/share/man

# build the package
make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|" \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.3|/usr/lib/tdbc1.1.3|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/generic|/usr/include|"         \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/library|/usr/lib/tcl8.6|"      \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3|/usr/include|"                 \
    -i pkgs/tdbc1.1.3/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.2|/usr/lib/itcl4.2.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.2/generic|/usr/include|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.2|/usr/include|" \
    -i pkgs/itcl4.2.2/itclConfig.sh
unset SRCDIR

make test > test_result.log
make install
# make the installed library writable so debugging symbols can be removed later.
chmod -v u+w /usr/lib/libtcl8.6.so

# package expect needs tcl's header
make install-private-headers
# make necessary symbolic link
ln -sfv tclsh8.6 /usr/bin/tclsh
# rename a man page that conflicts with a Perl man page
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

# install the optional documentation
mkdir -v -p /usr/share/doc/tcl-8.6.12
cp -v -r ../html/* /usr/share/doc/tcl-8.6.12

popd
