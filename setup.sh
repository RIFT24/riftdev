#!/bin/bash

echo " ____  __  ____  ____ "
echo "(  _ \(  )(  __)(_  _)"
echo " )   / )(  ) _)   )(  "
echo "(__\_)(__)(__)   (__) "

echo "This is the setup program for a new server for RIFT!"
echo "This should be an ubuntu 22 server and this script should be run with sudo"

echo -n "Ready to proceed? [Press ENTER]"
read proceed1


apt-get update
apt-get install docker docker-compose nginx git cockpit maven -y
snap install certbot --classic

cd /

mkdir /deployments
git clone https://github.com/RIFT24/riftdev.git

ufw allow openssh 
ufw allow 'Nginx Full' 
ufw delete allow 'Nginx HTTP' 
ufw enable 

chmod 755 /deployments
chmod 755 /deployments/*
chown ubuntu /deployments
chgrp ubuntu /deployments

cd /

rm -rf /etc/update-motd.d/00-header
cp /riftdev/scripts/00-header /etc/update-motd.d/00-header
chmod +x /etc/update-motd.d/00-header
mv /etc/update-motd.d/10-* /riftdev/
mv /etc/update-motd.d/9* /riftdev/

chmod +x /riftdev/scripts/*
chmod +x /riftdev/update.sh

cp /riftdev/scripts/build.sh /usr/bin/build
chmod +x /usr/bin/build

cp /riftdev/scripts/main.sh /usr/bin/rift
chmod +x /usr/bin/rift

echo "Setup Complete" 