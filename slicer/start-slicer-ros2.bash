#!/usr/bin/env bash

source /opt/ros/jazzy/setup.bash

# if the file exists, then run it
if [ -f /root/slicer/Slicer-5.8/Slicer ]; then
    /root/slicer/Slicer-5.8/Slicer
elif [ -f /root/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer ]; then
    /root/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer
fi
