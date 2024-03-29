#!/bin/bash

echo -n "Enter github link: "
read link

echo -n "Enter repository name: "
read name

echo -n "Port: "
read port

cd /deployments/

if [ -d "/deployments/$name" ]; then
    echo "Folder already in use. Rename and try again"
    exit 1
fi

git clone $link

cd $name

source /riftdev/scripts/build.sh

echo "Container active. Proceeding to verification"

echo "Take a moment to configure route53. If you do not know how, take a look at the RIFT deployment guide: https://rift24.github.io/RIFT-Frontend/"
echo -n "Enter in your domain (ex: ww3.stu.nighthawkcodingsociety.com): "
read domain

echo "Building configuration..."
sleep 2

if [ -f "/etc/nginx/sites-available/$name" ]; then
    echo "File already in use. Rename and try again manually."
    exit 1
fi

sudo touch /etc/nginx/sites-available/$name
sudo echo "server {" >> /etc/nginx/sites-available/$name
sudo echo "   listen 80;" >> /etc/nginx/sites-available/$name
sudo echo "    listen [::]:80;" >> /etc/nginx/sites-available/$name
sudo echo "    server_name $domain ;" >> /etc/nginx/sites-available/$name
sudo echo "    location / { " >> /etc/nginx/sites-available/$name
sudo echo "        proxy_pass http://localhost:$port;" >> /etc/nginx/sites-available/$name
sudo echo "$(cat /riftdev/scripts/nginx_sample_config_end)" >> /etc/nginx/sites-available/$name

cd /
sudo ln -s /etc/nginx/sites-available/$name /etc/nginx/sites-enabled/

echo "Configuration complete. If nginx status is OK, proceed. Otherwise, let RIFT know!"
sudo nginx -t
echo -n "Nginx config test result (GOOD/BAD) <-- Type them out exactly: "
read testresult
if [ "$testresult" == "BAD" ]; then
    echo "There has been some problem with the script. Please contact Rachit and RIFT IMMEDIATLEY"
    exit 1 # when you create a deployment server status page make sure to check here!
elif [ "$testresult" == "GOOD" ]; then
    echo "Proceeding..."
else
    echo "Sleeping for 60 seconds. Ctrl-C if there is a problem. If not, wait and reflect on your actions. If there is a problem, contact Rachit and RIFT IMMEDIATLEY."
    sleep 60
fi

echo "Restarting nginx..."
sudo service nginx restart
sudo service nginx status

echo "Certbot Configuration"
certbot --nginx

echo "Deployment script complete. Your site should now be live"