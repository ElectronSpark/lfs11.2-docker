#!/bin/bash

mkdir -pv /build/iana-etc
tar -xf /pkgs/iana-etc-20220812.tar.gz  \
    -C /build/iana-etc --strip-components 1

cp /build/iana-etc/{services,protocols} /etc
