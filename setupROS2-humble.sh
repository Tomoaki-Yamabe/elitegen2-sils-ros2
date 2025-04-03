#!/bin/bash

# proxy parameter
proxy_uri="10.121.48.30:8080"
proxy_user="J0115457"
proxy_password="Kitelevos22"

# setup proxy 
export http_proxy="http://$proxy_user:$proxy_password@$proxy_uri"
export https_proxy="http://$proxy_user:$proxy_password@$proxy_uri"

sudo apt install -y ros-humble-desktop python3-colcon-common-extensions -o Acquire::https::Proxy=$https_proxy

# ROS2環境設定
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc