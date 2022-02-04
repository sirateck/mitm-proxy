#!/bin/env bash
# Install nodejs 16x Using Debian, as root
NODE_MAJOR_VERSION=16.x
curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION | bash -
apt-get update && apt-get install -y nodejs git

# install yarn
sudo -u $USER npm install --global yarn

# install pm2 to demonize the proxy script
sudo -u $USER yarn global add pm2

# clone proxy script
sudo -u $USER git clone https://github.com/sirateck/mitm-proxy.git

cd mitm-proxy

# start proxy application
sudo -u $USER pm2 start index.ts
