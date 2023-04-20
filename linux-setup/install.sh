#!/bin/bash

cd ~

# Install docker
sudo apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
rm get-docker.sh

# Install vscode
curl -fsSL https://code-server.dev/install.sh | sh

# Install ngrok
ngrok_link="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
wget -c $ngrok_link -O - | tar -xz

