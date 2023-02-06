#!/bin/bash

mkdir -pv /{build,sources}/bash
tar -xf /pkgs/bash-5.1.16.tar.gz                \
    -C /sources/bash --strip-components 1

cd /build/bash

/sources/bash/configure                 \
    --prefix=/usr                       \
    --docdir=/usr/share/doc/bash-5.1.16 \
    --without-bash-malloc               \
    --with-installed-readline

make

# run test before installation
chown -Rv tester .
su -s /usr/bin/expect tester << EOF
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF

make install

# after installation, switch to the newly compiled bash program
exec /usr/bin/bash --login

cd /
