#!/bin/bash
set -euo pipefail

# Install f1x, prophet, genprog, dependencies for Ubuntu 14.04 62bit

DOWNLOAD="wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries=5 --continue"

INSTALL="sudo apt-get -y install"

cd "$( dirname "${BASH_SOURCE[0]}" )"


echo Installing Clang+LLVM 3.6.2, building prophet

$DOWNLOAD http://releases.llvm.org/3.6.2/clang+llvm-3.6.2-x86_64-linux-gnu-ubuntu-14.04.tar.xz
tar xf clang+llvm-3.6.2-x86_64-linux-gnu-ubuntu-14.04.tar.xz
(
    export PATH=$PWD/clang+llvm-3.6.2-x86_64-linux-gnu-ubuntu-14.04/bin:$PATH
    ./get-prophet
    cd prophet
    make
)
