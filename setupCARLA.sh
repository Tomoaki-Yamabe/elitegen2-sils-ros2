#!/bin/bash

# setup proxy 
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id proxy-config-yamabe --query SecretString --output text --region us-west-2)
export http_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
export https_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
mkdir -p ~/simulators
cd ~/simulators
wget -e HTTP_PROXY=$http_proxy https://github.com/carla-simulator/carla/releases/0.9.13/CARLA_0.9.13.tar.gz
tar -xvzf CARLA_0.9.13.tar.gz
./CarlaUE4.sh -opengl