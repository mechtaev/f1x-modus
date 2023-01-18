#!/bin/bash
set -euo pipefail

# Install f1x, prophet, genprog, dependencies for Ubuntu 14.04 62bit

DOWNLOAD="wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries=5 --continue"

INSTALL="sudo apt-get -y install"

cd "$( dirname "${BASH_SOURCE[0]}" )"


echo Installing dependencies

$INSTALL git mercurial subversion build-essential
$INSTALL unzip time
$INSTALL libboost-filesystem-dev libboost-program-options-dev libboost-log-dev # f1x
$INSTALL psmisc # experiments scripts
$INSTALL zlib1g-dev libexplain-dev # prophet
$INSTALL gawk # libtiff
$INSTALL re2c bison # php
$INSTALL libglib2.0-dev libsqlite3-dev # lighttpd
$INSTALL texinfo # gmp
$INSTALL libffi-dev gtk-doc-tools libgtk2.0-dev libqt4-dev libgtk-3-dev libpcap-dev flex # wireshark
$INSTALL sa-compile # don't know why
$INSTALL libncurses5-dev # python
$INSTALL ocaml camlp4 ocaml-findlib # genprog
$INSTALL libcunit1-dev #fbc

