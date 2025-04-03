#!/bin/bash

# setup proxy 
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id proxy-config --query SecretString --output text)
export http_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
export https_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)

sudo apt update
sudo apt install -y unzip curl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

aws --version
