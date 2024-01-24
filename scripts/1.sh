#!/bin/bash

echo -n "Enter github link: "
read link

echo -n "Enter repository name: "
read name

echo -n "Port: "
read port

cd /deployments/


echo "Now checking your dockerfile. Is your port configured to not overlap with any other deployment ports? Is it a port that is not in use by the system?"
echo "You may want to choose a port in the 8--- range except for 8085 (ngnix www port)"
sudo docker ps
echo -n "Is your port ready for use (YES/NO) <-- Type them out exactly: "
read use

if [ "$use" == "NO" ]; then
    echo "Exiting, make sure you change it"
    exit 1
elif [ "$use" == "YES" ]; then
    echo "Continuing..."
else
    echo "Please put in a valid input. Terminating the script."
    exit 1
fi


if [ -d "/deployments/$name" ]; then
    echo "Folder already in use. Rename and try again"
    exit 1
fi

git clone $link

cd $name

docker-compose up -d --build

echo "Container active. Proceeding to verification"
echo "Make sure this is your homepage"
sleep 2
curl localhost:$port

echo -n "Is this your page? (YES/NO) <-- Type them out exactly: "
read page
if [ "$page" == "NO" ]; then
    echo "There has been some problem with the script. Please contact Rachit and RIFT IMMEDIATLEY"
    exit 1 # when you create a deployment server status page make sure to check here!
elif [ "$page" == "YES" ]; then
    echo "Proceeding..."
else
    echo "Sleeping for 60 seconds. Ctrl-C if there is a problem. If not, wait and reflect on your actions. If there is a problem, contact Rachit and RIFT IMMEDIATLEY."
    sleep 60
fi

echo "Take a moment to configure route53. If you do not know how, take a look at the RIFT deployment guide: https://rift24.github.io/RIFT-Frontend/"
echo -n "Enter in your domain (ex: ww3.stu.nighthawkcodingsociety.com): "
read domain

echo "Building configuration..."
sleep 2

if [ -f "/etc/nginx/sites-availible/$name" ]; then
    echo "File already in use. Rename and try again manually."
    exit 1
fi

sudo touch /etc/nginx/sites-availible/$name
sudo echo "server {"
sudo echo "   listen 80;"
sudo echo "    listen [::]:80;"
sudo echo "    server_name $domain"
sudo echo "    location / { "
sudo echo "        proxy_pass http://localhost:$port"
sudo echo "$(cat /riftdev/scripts/nginx_sample_conf_end)" >> /etc/nginx/sites-availible/$name

cd /
sudo ln -s /etc/nginx/sites-availible/$name /etc/nginx/sites-enabled/

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

echo "Deployment script complete. Your site should now be live"