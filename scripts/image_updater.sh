#!/bin/bash

IMAGE_TAG=$1

if [ -z "$IMAGE_TAG" ]; then
  echo "Error: Please provide an image tag."
  exit 1
fi

# IMAGE UPDATER
echo "Updating ecs.tf with the new image tag: $IMAGE_TAG"
sed -i "s|image\s*=\s*\".*\"|image = \"$IMAGE_TAG\"|" kubernetes\deployment.yaml

if [ $? -eq 0 ]; then
  echo "ecs.tf file updated successfully with image tag: $IMAGE_TAG"
else
  echo "Error: Failed to update ecs.tf."
  exit 1
fi
