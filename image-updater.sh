#!/bin/bash

IMAGE_TAG=$1

# IMAGE UPDATER
echo "Updating deployment.yam with the new image tag: $IMAGE_TAG"
sed -i "s|image\s*=\s*\".*\"|image = \"$IMAGE_TAG\"|" k8s/deployment.yaml

echo "deployment.yaml file updated successfully with image tag: $IMAGE_TAG"
