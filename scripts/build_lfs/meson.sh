#!/bin/bash

mkdir -pv /build/meson
tar -xf /pkgs/meson-0.63.1.tar.gz           \
    -C /build/meson --strip-components 1

pushd /build/meson

pip3 wheel -w dist --no-build-isolation --no-deps $PWD

# install the package
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

popd
