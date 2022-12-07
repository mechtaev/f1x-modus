#!/bin/bash

require () {
    hash "$1" 2>/dev/null || { echo "command $1 is not found"; exit 1; }
}

require cilly
require genprog

usage="Usage: ./repair SUBJECT VERSION"

if [[ $# > 0 ]]; then
    subject="$1"
    shift
else
    echo "$usage"
    exit 1
fi

if [[ $# > 0 ]]; then
    version="$1"
    shift
else
    echo "$usage"
    exit 1
fi

ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source_dir="${subject}-${version}/workdir/src"
workdir="${subject}-${version}/workdir/tempsrc"
cp -r $source_dir $workdir
(
    ./configure ${subject} ${version} "genprog"
    cd $workdir
    echo "compiling for preprocess"
    #make CC="cilly" CFLAGS="--save-temps -std=c99 -fno-optimize-sibling-calls -fno-strict-aliasing -fno-asm" &> initialbuild
    make CC="cilly --save-temps -std=c99 -fno-optimize-sibling-calls -fno-strict-aliasing -fno-asm" &> initialbuild
if grep -q "Error:" initialbuild; then
    if grep -q "Length of array is not" initialbuild; then
       printf "%s\t%s\t%s\n" "$version" "BUILD:ARRAY BUG" "0s" >> "$rootdir/genprog-summary.log"
    else
       echo "BUILD FAILED"
       printf "%s\t%s\t%s\n" "$version" "BUILDFAILED!" "0s" >> "$rootdir/genprog-summary.log"
       fi
       continue
    fi
)

cp "${ROOT}/genprog_compile/${subject}_compile.pl" "$workdir/compile.pl"
negative_tests=`$ROOT/query negative-reproducible $subject $version`
positive_tests=`$ROOT/query positive-reproducible $subject $version`
cfile=$(grep "bugged_file" ${subject}-${version}/prophet.conf | cut -d$'=' -f2)

cilfile=$(echo $(echo $cfile | cut -d$"." -f1).cil.c)
cd $workdir
rm -rf preprocessed
mkdir -p `dirname preprocessed/$cfile`
cp $cilfile preprocessed/$cfile
cp preprocessed/$cfile $cfile
rm -rf coverage
rm -rf coverage.path.*
rm -rf repair.cache
rm -rf repair.debug.*

driver="$ROOT/genprog_driver"
time_out="3h"
buggy_file=`$ROOT/query buggy-file $subject $version`
output_patch="genprog-${subject}-${version}.patch"

export F1X_SUBJECT=$subject
export F1X_VERSION=$version
echo $cfile > bugged-program.txt

echo genprog repairing $subject $version

cp $ROOT/configuration-default .
echo "--pos-tests `expr $(echo $positive_tests | tr -cd ' ' |wc -c) + 1`">>configuration-default
echo "--neg-tests `expr $(echo $negative_tests | tr -cd ' ' |wc -c) + 1`">>configuration-default
echo "--test-script $driver">>configuration-default
echo "--continue">>configuration-default

echo "cmd: timeout -k 9 $time_out genprog configuration-default"
timeout -k 9 $time_out genprog configuration-default > genprog-run.out

cd $ROOT

timespent=$(grep "TOTAL" "$workdir/genprog-run.out" | cut -d'=' -f1 | awk '{print $NF}')
   echo "timespent:$timespent"
if [ -z "${timespent}" ]; then
        printf "%s\t%s\t%s\n" "$version" "TIMEOUT" "3600s" >> "$workdir/genprog-summary.log"
fi

if [ ! -f "$workdir/build.log" ]
then
      printf "%s\t%s\t%s\n" "$version" "BUILDFAILED:FILE!" "$timespent" >> "$workdir/genprog-summary.log"
fi

   if grep -q "Failed to make" $workdir/build.log; then
       echo "BUILD FAILED"
       printf "%s\t%s\t%s\n" "$version" "BUILDFAILED!" "$timespent" >> "$workdir/genprog-summary.log"
   elif  grep -q "nexpected" "$workdir/genprog-run.out"; then
       echo "Verification failed"
       printf "%s\t%s\t%s\n" "$version" "Verification failed!" "$timespent" >> "$workdir/genprog-summary.log"
   elif grep -q "Timeout" "$workdir/genprog-run.out"; then
       printf "%s\t%s\t%s\n" "$version" "TIMEOUT" "$timespent" >> "$workdir/genprog-summary.log"
   elif grep -q "Repair Found" "$workdir/genprog-run.out"; then
            #contestnum=$(echo "$version" | cut -d$'-' -f1)
            #probnum=$(echo "$version" | cut -d$'-' -f2)
            #buggyfile=$(echo "$version" | cut -d$'-' -f4)
            #cfile=$(echo "$contestnum-$probnum-$buggyfile".c)
            #cfixfile=$(echo "$version-fix".c)
            fixf="$workdir/repair/$cfile"
            echo "patch file" fixf
	    #sed -i '/booo/d' "$fixf"  
            #cp $fixf $rootdir/genprog-allfixes/$cfixfile
           #$rootdir/validate-fix-genprog.sh "$version" "$workdir/genprog-run.out" "$rundir/tempworkdir-$version" "$timespent"
           echo "PASS:$passt"

           #printf "%s\t%s\t%s\n" "$version" "YES" "$timespent" >> "$rootdir/genprog-summary.log"
     elif grep -q "no repair" "$workdir/genprog-run.out"; then
           printf "%s\t%s\t%s\n" "$version" "NO" "$timespent" >> "$workdir/genprog-summary.log"
     elif grep -q "Assertion failed" "$workdir/genprog-run.out"; then
           printf "%s\t%s\t%s\n" "$version" "COVERAGEFAIL" "$timespent" >> "$workdir/genprog-summary.log"

     fi
