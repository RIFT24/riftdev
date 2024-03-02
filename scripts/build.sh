#!/bin/bash

# Ask the user for the port to check
# Get the list of unique ports used by Docker containers
ports=$(docker ps --format "{{.Ports}}" | awk -F '[,:]+' '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+->/) print substr($i, 1, index($i,"->")-1)}' | sort -u)

# Flag to indicate if the port is found
port_found=false

# Use the current working directory to find the Dockerfile
dockerfile_path="$(pwd)/Dockerfile"

# Extract the port using awk
port_to_check=$(awk '/EXPOSE/ {print $2; exit}' "$dockerfile_path")

# Iterate through the list of ports
for port in $ports; do
    if [ "$port" == "$port_to_check" ]; then
        port_found=true
        break
    fi
done

# Output the result
if $port_found; then
    echo "Port $port_to_check is used by a Docker container."
    exit 1
else
    echo "Port $port_to_check is not used by any Docker container."
fi

./mvnw clean
docker-compose up -d --build