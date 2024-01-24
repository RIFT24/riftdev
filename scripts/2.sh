#!/bin/bash

echo -n "Enter repository name: "
read name

cd /deployments/$name/

docker-compose down
git pull
./mvnw clean
docker-compose up -d --build

echo -n "Are changes showing up on your website? (YES/NO) <-- Type them out exactly: "
read page
if [ "$page" == "NO" ]; then
    echo "Restarting nginx. Everything should be fine now given you have not configured anything incorrectly"
    service nginx restart
    service nginx status
elif [ "$page" == "YES" ]; then
    echo "Complete. "
else
    echo "Sleeping for 60 seconds. Ctrl-C if there is a problem. If not, wait and reflect on your actions. If there is a problem, contact Rachit and RIFT IMMEDIATLEY."
    sleep 60
fi

