#!/bin/bash


cd autoware

# first setup
./tools/docker/build.sh
./tools/docker/run.sh

# runch autoware docker
./docker/run.sh --devel --workspace $(pwd)

# in container
cd workspace
source /opt/ros/humble/setup.bash # read enviroment
colcon build --symlink-install
source install/setup.bash # read enviroment

ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$HOME/autoware_map/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit