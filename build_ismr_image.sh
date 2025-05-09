#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

# Make sure we're in the correct directory
cd "$(dirname "$0")"
WORKING_DIR=$(pwd)

echo "Building ISMR 2025 Docker images..."
echo "Current directory: $WORKING_DIR"

# Step 1: Build base and Slicer images
echo -e "\n[Step 1] Building base and Slicer images..."
docker build -f Dockerfile.base.amd64 . -t rosmed/docker-ubuntu-vnc-desktop-base:ismr2025
docker build -f Dockerfile.slicer . -t rosmed/docker-ubuntu-vnc-desktop-slicer:ismr2025
docker build -f Dockerfile.slicerpackage . -t rosmed/docker-ubuntu-vnc-desktop-slicerpackage:ismr2025

# Step 2: Copy Slicer packages from container
echo -e "\n[Step 2] Launching container to extract Slicer packages..."
SLICER_CONTAINER_ID=$(docker run -d rosmed/docker-ubuntu-vnc-desktop-slicerpackage:ismr2025)
echo "Launched container with ID: $SLICER_CONTAINER_ID"

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 10

# Create packages directory if it doesn't exist
mkdir -p packages

echo "Copying Slicer packages from container..."
docker cp $SLICER_CONTAINER_ID:/root/slicer/packages/. packages/
echo "Stopping container..."
docker stop $SLICER_CONTAINER_ID

# Step 3: Build SlicerROS
echo -e "\n[Step 3] Building SlicerROS2 image..."
docker build -f Dockerfile.slicerros2 . -t rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025

# Step 4: Extract ROS workspace
echo -e "\n[Step 4] Launching container to extract ROS workspace..."
ROS_CONTAINER_ID=$(docker run -d rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025)
echo "Launched container with ID: $ROS_CONTAINER_ID"

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 10

echo "Copying ROS workspace from container..."
docker cp $ROS_CONTAINER_ID:/root/ros2_ws .
echo "Creating ROS workspace archive..."
tar czvf ros2_ws.tar.gz ros2_ws
echo "Stopping container..."
docker stop $ROS_CONTAINER_ID

# Step 5: Build lightweight Docker image
echo -e "\n[Step 5] Building lightweight Docker image..."
docker build -f Dockerfile.slicerros2.lw . -t rosmed/docker-ubuntu-vnc-desktop-slicerros2-lw:ismr2025

# Step 6: Push images (optional, commented out by default)
echo -e "\n[Step 6] Pushing Docker images to registry..."
echo "Note: Uncomment the following lines if you want to push the images"
echo "# docker push rosmed/docker-ubuntu-vnc-desktop-base:ismr2025"
echo "# docker push rosmed/docker-ubuntu-vnc-desktop-slicer:ismr2025"  
echo "# docker push rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025"
echo "# docker push rosmed/docker-ubuntu-vnc-desktop-slicerros2-lw:ismr2025"

echo -e "\nBuild process completed successfully!"