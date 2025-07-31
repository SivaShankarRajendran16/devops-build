#!/bin/bash
set -e

TAG=${1:-dev}
IMAGE_NAME="my-nginx-app"

docker build -t $DOCKER_USER/$TAG:$BUILD_NUMBER .
