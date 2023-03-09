#!/bin/bash
set -euo pipefail


docker rm env

docker rmi environments:f1x-manybugs
