#!/bin/bash

require () {
    hash "$1" 2>/dev/null || { echo "command $1 is not found"; exit 1; }
}

require f1x


ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

subjects="libtiff lighttpd php gmp gzip python wireshark fbc"
logfile=log.txt
timeout=4h

for subject in $subjects; do
    for version in `./query versions $subject`; do
        echo fetching $subject $version | tee -a $logfile
        ./fetch $subject $version
        echo configuring $subject $version | tee -a $logfile
        CC=f1x-cc ./configure $subject $version &> /dev/null
        timeout $timeout ./repair-f1x $subject $version 2>&1 | tee -a $logfile
        rm -rf ${subject}-${version}
    done
done
