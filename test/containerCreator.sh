#!/bin/bash
set -euo pipefail

version=$1

echo Print proof tree
modus proof . 'patch'$version'("f1x", "demo")'

echo Build image based on Modusfile
modus build . 'patch'$version'("f1x", "demo")' --json=build.json

jq . build.json

jq '.[] | [.digest, .predicate + ":" + (.args | join("-"))] | join(" ")' build.json | xargs -I % sh -c 'docker tag %'

echo Show new image
docker images | grep patch$version

echo Create container with the name of testenv_$version
docker create -ti --name testenv_$version patch$version:f1x-demo /bin/bash
