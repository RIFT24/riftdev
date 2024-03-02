#!/bin/bash

rm -rf /usr/bin/build
cp /riftdev/scripts/build.sh /usr/bin/build
chmod +x /usr/bin/build

rm -rf /usr/bin/rift
cp /riftdev/scripts/main.sh /usr/bin/rift
chmod +x /usr/bin/rift