#!/usr/bin/env bash
# Script to build a single-platform docker image locally and deploy directly to a LibreELEC machine via SSH.

set -e

# Change directory to the repository root
cd "$(dirname "$0")/.."

HOST="${1:-}"
TAG="${2:-2026.7.0}"

if [ -z "$HOST" ]; then
    echo "Usage: ./scripts/deploy-libreelec.sh <LIBREELEC_IP_OR_HOSTNAME> [TAG]" >&2
    echo "Example: ./scripts/deploy-libreelec.sh 192.168.0.110 2026.7.0" >&2
    exit 1
fi

IMAGE_NAME="ghcr.io/shardshunt/sendspin-cli-for-sendspin-kodi:${TAG}"

echo "=========================================================="
echo "Building local image for LibreELEC host: ${HOST}"
echo "Target Image: ${IMAGE_NAME}"
echo "=========================================================="

echo "Building native/local image..."
docker build -t "$IMAGE_NAME" .

echo "Deploying image to ${HOST} via SSH (docker save | ssh docker load)..."
docker save "$IMAGE_NAME" | ssh "root@${HOST}" docker load

echo "=========================================================="
echo "Successfully built and deployed ${IMAGE_NAME} to ${HOST}!"
echo "=========================================================="
