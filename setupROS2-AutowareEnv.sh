#!/bin/bash


# setup proxy 
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id proxy-config-yamabe --query SecretString --output text --region us-west-2)
export http_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
export https_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
# Docker
sudo apt update -y -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy
sudo apt install -y docker.io -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

# NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update -y -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy
sudo apt install -y nvidia-container-toolkit -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy
sudo systemctl restart docker


# needs package
sudo apt install -y python3-vcstool x11-xserver-utils -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy

# clone autoware
git config --global http.proxy $https_proxy
git config --global https.proxy $https_proxy
git clone https://github.com/autowarefoundation/autoware.git
