#!/bin/bash
set -euo pipefail

version=$1
category=$2

docker rm testenv_$version

docker rmi patch$version:$catgory
