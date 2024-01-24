#!/bin/bash

cd /riftdev/scripts

if [ -d "/deployments" ]; then
    if [ -d "/riftdev" ]; then
        echo "Initialization checks passed"
    else
        echo "Initialization checks failed."
        exit 1
    fi
else
    echo "Initialization checks failed."
    exit 1
fi

echo " ____  __  ____  ____ "
echo "(  _ \(  )(  __)(_  _)"
echo " )   / )(  ) _)   )(  "
echo "(__\_)(__)(__)   (__) "

echo "RIFT - Options"
echo "1. Deploy new server"
echo "2. Update existing server"
echo "3. Edit server configuration (NANO)"
echo "4. Debug Menu"
echo "5. Quit"

echo -n "> " 
read mainpage

if [ "$mainpage" == '1' ]; then
    echo "Initializing deployment process for new server"
    source /riftdev/scripts/1.sh
elif [ "$mainpage" == '2' ]; then
    echo "Initializing update process for existing deployment"
    source /riftdev/scripts/2.sh
elif [ "$mainpage" == '3' ]; then
    echo "Initializing server configuration editor" 
    source /riftdev/scripts/3.sh
elif [ "$mainpage" == '4' ]; then
    echo "Initializing the debug menu"
    source /riftdev/scripts/4.sh
elif [ "$mainpage" == '5' ]; then
    echo "Quitting..."
    exit 1
else
    echo "Choose a valid option (dont add extra characters)"
fi

exit 0
