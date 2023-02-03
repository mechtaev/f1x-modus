#!/bin/bash
set -euo pipefail


echo Print proof tree
modus proof . 'environments("f1x")'

echo Build image based on Modusfile
modus build . 'environments("f1x")' --json=build.json

jq . build.json

jq '.[] | [.digest, .predicate + ":" + (.args | join("-"))] | join(" ")' build.json | xargs -I % sh -c 'docker tag %'

echo Show new image
docker images | grep environments

echo Create container with the name of env
docker create -ti --name env environments:f1x /bin/bash

docker start -ai env
