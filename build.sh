#!/bin/bash
set -e

# Arguments from Jenkins
BRANCH_NAME=$1

# These env vars are passed from Jenkins
: "${DOCKER_USER:?Missing DOCKER_USER}"
: "${BUILD_NUMBER:?Missing BUILD_NUMBER}"

# Determine the repo (dev or prod)
if [ "$BRANCH_NAME" == "dev" ]; then
  REPO="dev"
elif [ "$BRANCH_NAME" == "main" ]; then
  REPO="prod"
else
  echo "❌ Unsupported branch: $BRANCH_NAME"
  exit 1
fi

# Final image name
IMAGE_NAME="${DOCKER_USER}/${REPO}:${BUILD_NUMBER}"

echo "🔧 Building Docker image: $IMAGE_NAME"

# Build using Dockerfile (assumes it's in current dir)
docker build -t "$IMAGE_NAME" .

echo "✅ Built image: $IMAGE_NAME"


