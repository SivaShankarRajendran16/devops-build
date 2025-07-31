#!/bin/bash
set -e

docker compose down || true
docker compose build
docker compose up -d


