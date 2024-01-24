#!/bin/bash

echo "Displaying outputs of all debug commands... (if you need to debug your specific repository do that on localhost)"
docker ps
ps -aux
nginx -t
service nginx status
ufw status
