#!/bin/bash
set -e

docker-compose down || true
docker-compose up -d
