#!/bin/bash
set -euo pipefail

# Install f1x, prophet, genprog, dependencies for Ubuntu 14.04 62bit

DOWNLOAD="wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries=5 --continue"

INSTALL="sudo apt-get -y install"

cd "$( dirname "${BASH_SOURCE[0]}" )"


echo Installing new CMake

$DOWNLOAD https://cmake.org/files/v3.7/cmake-3.7.1.tar.gz
tar xf cmake-3.7.1.tar.gz
(
    cd cmake-3.7.1
    ./bootstrap
    make
    sudo make install
)

