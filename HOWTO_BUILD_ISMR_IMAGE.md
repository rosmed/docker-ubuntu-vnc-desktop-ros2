Building the docker images
==========================

Slicer and Slicer Extensions
----------------------------

Move to the directory where the Dockerfile:

~~~~
cd /path/to/docker-ubuntu-vnc-desktop-ros2/
~~~~

Then, run the following commands:
~~~~
docker build -f Dockerfile.base.amd64 . -t rosmed/docker-ubuntu-vnc-desktop-base:ismr2025
docker build -f Dockerfile.slicer . -t rosmed/docker-ubuntu-vnc-desktop-slicer:ismr2025
docker build -f Dockerfile.slicerpackage . -t rosmed/docker-ubuntu-vnc-desktop-slicerpackage:ismr2025
~~~~


Copy the Slicer packages
------------------------
Launch the Slicer Docker image:

~~~~
docker run -it --rm -p 6080:80 rosmed/docker-ubuntu-vnc-desktop-slicerpackage:ismr2025
~~~~

Open a new terminal and run the following commands to check the container ID:

~~~~
docker container ls
~~~~

This will return a list of running containers, for example:

~~~~
CONTAINER ID   IMAGE                                              COMMAND         CREATED          STATUS                             PORTS                                   NAMES
64895f315348   rosmed/docker-ubuntu-vnc-desktop-slicerpackage:ismr2025   "/startup.sh"   56 seconds ago   Up 56 seconds (health: starting)   0.0.0.0:6080->80/tcp, :::6080->80/tcp   sharp_fermat
~~~~

In this example, the container ID is `64895f315348`. Then copy the binary files from the container to the host using the following commands:

~~~~
docker cp 64895f315348:/root/slicer/packages .
~~~~


Build SlicerROS
---------------

~~~~
docker build -f Dockerfile.slicerros2 . -t rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025
~~~~

Make SlicerROS package
-----------------------

~~~~
docker run -it --rm -p 6080:80 rosmed/docker-ubuntu-vnc-desktop-slicerros2package:ismr2025
~~~~

~~~~
docker cp <container ID>:/root/slicer/packages .
~~~~





Uploading the docker images
----------------------------
~~~~
docker push rosmed/docker-ubuntu-vnc-desktop-base:ismr2025
docker push rosmed/docker-ubuntu-vnc-desktop-slicer:ismr2025
docker push rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025
~~~~


Copy the ROS workspace 
----------------------
Launch the Slicer Docker image:

~~~~
docker run -it --rm -p 6080:80 rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025
~~~~

Open a new terminal and run the following commands to check the container ID:

~~~~
docker container ls
~~~~

This will return a list of running containers, for example:

~~~~
CONTAINER ID   IMAGE                                                  COMMAND         CREATED       STATUS                 PORTS                                   NAMES
6d10162752a4   rosmed/docker-ubuntu-vnc-desktop-slicerros2:ismr2025   "/startup.sh"   5 hours ago   Up 5 hours (healthy)   0.0.0.0:6080->80/tcp, :::6080->80/tcp   gifted_pasteur
~~~~

In this example, the container ID is `6d10162752a4` Then copy the binary files from the container to the host and archive using the following commands:

~~~~
docker cp 64895f315348:/root/ros2_ws .
tar czvf ros2_ws.tar.gz ros2_ws
~~~~



Build the lightweight Docker files
----------------------------------

Finally, build the docker file with the extracted binary files.

~~~~
docker build -f Dockerfile.slicerros2.lw . -t rosmed/docker-ubuntu-vnc-desktop-slicerros2-lw:ismr2025
docker push rosmed/docker-ubuntu-vnc-desktop-slicerros2-lw:ismr2025
~~~~


