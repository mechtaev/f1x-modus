#!/bin/bash
set -euo pipefail

# Remove the 'env' container if it exists
docker rm -f env || true

# Remove matching images
docker images --format "{{.Repository}}:{{.Tag}}" | grep "^environments:f1x-manybugs" | xargs -r docker rmi
