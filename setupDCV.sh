#!/bin/bash



# setup proxy 
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id proxy-config-yamabe --query SecretString --output text --region us-west-2)
export http_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)
export https_proxy=$(echo $SECRET_JSON | jq -r .https_proxy)

echo  " ----------- Installing required packages ----------- " 
sudo apt install -y wget curl gnupg lsb-release unzip -o Acquire::http::Proxy=$http_proxy -o Acquire::https::Proxy=$https_proxy
sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-desktop gdm3 -o Acquire::https::Proxy=$https_proxy


echo  " ----------- Disable Wayland ----------- " 
CONF_FILE="/etc/gdm3/custom.conf"
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' $CONF_FILE
if ! grep -q "WaylandEnable=false" $CONF_FILE; then
  echo -e "\n[daemon]\nWaylandEnable=false" | sudo tee -a $CONF_FILE
fi


echo "----------- Restart GDM3 -----------"
sudo systemctl restart gdm3 || true  # GDM3 might not be active yet


echo "----------- Install NVIDIA driver -----------"
sudo apt install -y nvidia-driver-535
sudo reboot


echo  " ----------- Installing NICE DCV ----------- " 
wget https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY
gpg --import NICE-GPG-KEY

# ubuntu 22 x86
wget https://d1uj6qtbmh3dt5.cloudfront.net/nice-dcv-ubuntu2204-x86_64.tgz

tar -xvzf nice-dcv-ubuntu2204-x86_64.tgz
cd nice-dcv-2024.0-19030-ubuntu2204-x86_64
sudo apt install -y ./nice-dcv-server_*.deb ./nice-dcv-web-viewer_*.deb ./nice-xdcv_*.deb -o Acquire::https::Proxy=$https_proxy


echo "----------- usersetting -----------"
sudo mkdir -p /etc/gdm3
sudo tee /etc/gdm3/custom.conf <<EOF
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=ubuntu
EOF

gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false


echo "----------- Configuring user session -----------"
sudo tee /etc/dcv/dcv.conf > /dev/null <<EOF
[license]
accept-eula = true

[session-management]
create-session = true
default-session-owner = ubuntu
enable-console-session = true

[session-management/automatic-console-session]
storage-root = ubuntu

[security]
authentication = none

[display]
gl-enable = true
enable-web-access = true

[display/linux]
gl-displays = true
EOF


echo "----------- xconfig -----------"
sudo nvidia-xconfig --preserve-busid --enable-all-gpus


echo "----------- Restarting DCV Server -----------"
sudo systemctl enable dcvserver
sudo systemctl start dcvserver

echo "NICE DCV installed and configured. Access with DCV client to this machine's IP."