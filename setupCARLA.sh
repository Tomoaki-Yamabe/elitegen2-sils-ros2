#!/bin/bash

# proxy parameter
proxy_uri="10.121.48.30:8080"
proxy_user="J0115457"
proxy_password="Kitelevos22"

mkdir -p ~/simulators
cd ~/simulators
wget -e HTTP_PROXY=$http_proxy https://github.com/carla-simulator/carla/releases/0.9.13/CARLA_0.9.13.tar.gz
tar -xvzf CARLA_0.9.13.tar.gz
./CarlaUE4.sh -opengl