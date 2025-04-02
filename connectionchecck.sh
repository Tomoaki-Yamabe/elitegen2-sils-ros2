#!/bin/bash

target_url="https://mirrors.ustc.edu.cn/ros2/ubuntu/"

# https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu/
# https://mirrors.ustc.edu.cn/ros2/ubuntu/
# https://mirrors.bfsu.edu.cn/ros2/ubuntu/
# https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu/

# プロキシの詳細を設定
proxy_uri="10.121.48.30:8080"
proxy_user="J0115457"
proxy_password="Kitelevos22"

# プロキシの環境変数を設定
export http_proxy="http://$proxy_user:$proxy_password@$proxy_uri"
export https_proxy="http://$proxy_user:$proxy_password@$proxy_uri"

# プロキシを通じてGoogleにリクエストを送信してテスト
response=$(curl -s -o /dev/null -w "%{http_code}" $target_url)

if [ $response -eq 200 ]; then
    echo "Success: Connected to through the proxy."
else
    echo "Failed to connect to the internet through the proxy."
fi

# ROS install

sudo rm -rf /etc/apt/sources.list.d.bak
sudo mv /etc/apt/sources.list.d /etc/apt/sources.list.d.bak
sudo rm -rf /etc/apt/sources.list.d
sudo mkdir /etc/apt/sources.list.d

# echo "deb [arch=$(dpkg --print-architecture)] $target_url $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list
# echo "deb [arch=amd64] $target_url jammy main" | sudo tee /etc/apt/sources.list.d/ros2.list
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] $target_url jammy main" | sudo tee /etc/apt/sources.list.d/ros2.list

sudo apt update -y -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy
# sudo apt upgrade -y -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy

# sudo apt install -y ros-humble-desktop python3-colcon-common-extensions