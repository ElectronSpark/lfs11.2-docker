#!/bin/bash

# allow a user to limit the number of parallel processes via an environment
# variable.
export NINJAJOBS=4

mkdir -pv /build/ninja
tar -xf /pkgs/ninja-1.11.0.tar.gz           \
    -C /build/ninja --strip-components 1

pushd /build/ninja

# add the capacity to use the environment variable NINJAJOBS
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

# build ninja.
# --bootstrap forces ninja to rebuild itself for the current system
python3 configure.py --bootstrap

# to test the result
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

# install the package
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion /usr/share/zsh/site-functions/_ninja

popd
