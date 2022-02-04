# Install nodejs 16x Using Debian, as root
NODE_MAJOR_VERSION=16.x
curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION | bash -
apt-get install -y nodejs

# install yarn
npm install --global yarn

# install pm2 to demonize the proxy script
yarn global add pm2

git clone 
