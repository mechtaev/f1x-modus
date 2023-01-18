#!/bin/bash
set -euo pipefail

# Install f1x, prophet, genprog, dependencies for Ubuntu 14.04 62bit

DOWNLOAD="wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries=5 --continue"

INSTALL="sudo apt-get -y install"

cd "$( dirname "${BASH_SOURCE[0]}" )"


echo Installing Clang+LLVM 3.8.1, building f1x

git clone https://github.com/mechtaev/f1x
$DOWNLOAD http://releases.llvm.org/3.8.1/clang+llvm-3.8.1-x86_64-linux-gnu-ubuntu-14.04.tar.xz
tar xf clang+llvm-3.8.1-x86_64-linux-gnu-ubuntu-14.04.tar.xz
(
    cd f1x
    mkdir build
    cd build
    cmake -DF1X_LLVM=$PWD/../../clang+llvm-3.8.1-x86_64-linux-gnu-ubuntu-14.04 ..
    make
)

PATH=/f1x-genprog-icse12/f1x/build/tools:$PATH

