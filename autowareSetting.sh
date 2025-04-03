#!/bin/bash

# sample setup
source /opt/ros/humble/setup.bash

# download sample map and censor data
mkdir -p ~/autoware-map/sample-map
cd ~/autoware-map/sample-map
wget https://github.com/tier4/autoware-map-sample/releases/download/v1.0/sample-map.tar.gz
tar -xzf sample-map.tar.gz

# upset
./docker/run.sh --devel --workspace $(pwd)

docker start -ai my-autoware-dev
docker exec -it my-autoware-dev bash

# setting autoware
cd /home/autoware/src
git clone https://github.com/tier4/sample_sensor_description.git

# sample
ros2 launch autoware_launch planning_simulator.launch.xml \
  map_path:=/home/autoware-map/sample-map \
  vehicle_model:=sample_vehicle \
  sensor_model:=sample_sensor_kit


# develop
./docker/run.sh --devel --workspace $(pwd)
cd workspace
source /opt/ros/humble/setup.bash # read enviroment
colcon build --symlink-install
source install/setup.bash # read enviroment

#sudo rm -rf build install log

# 
# http://qiita.com/Lagmbolr/autoware/
# autoware::velocity_limit_decider