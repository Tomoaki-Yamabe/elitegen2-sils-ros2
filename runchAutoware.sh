#!/bin/bash

cd autoware
./tools/docker/build.sh
./tools/docker/run.sh

ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$HOME/autoware_map/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit