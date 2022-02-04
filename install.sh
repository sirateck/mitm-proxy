#!/bin/env bash
# Install nodejs 16x Using Debian, as root
NODE_MAJOR_VERSION=16.x
curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION | bash -
apt-get update && apt-get install -y nodejs git

# install yarn
npm install --global yarn

# install pm2 to demonize the proxy script
yarn global add pm2 typescript ts-node

# install pm2 typescript
pm2 install typescript

# clone proxy script
git clone https://github.com/sirateck/mitm-proxy.git

chown -R $USER:$USER mitm-proxy/

# start proxy application
sudo -u $USER pm2 start $(pwd)/mitm-proxy/index.ts
