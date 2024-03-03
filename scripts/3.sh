#!/bin/bash

echo -n "Enter repository name: "
read name

sudo nano /etc/nginx/sites-available/$name

echo -n "Are you done [Press ENTER to continue]?"
read done
