#!/bin/bash



# setup proxy 
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id proxy-config-yamabe --query SecretString --output text --region us-west-2)
export http_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
export https_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
sudo apt install -y ros-humble-desktop python3-colcon-common-extensions -o Acquire::https::Proxy=$https_proxy

# ROS2環境設定
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc