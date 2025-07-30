#!/bin/bash

set -e

IMAGE_NAME="my-nginx-app"
TAG="latest"

echo "🔧 Building Docker image from Dockerfile..."
docker build -t $IMAGE_NAME:$TAG .

echo "✅ Docker image $IMAGE_NAME:$TAG built successfully."

