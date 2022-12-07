#!/bin/bash
set -euo pipefail

version=$1

docker rm testenv_$version

docker rmi patch$version:f1x-demo
