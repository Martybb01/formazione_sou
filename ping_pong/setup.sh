#!/bin/bash

NODE_NAME=$1

docker rm -f echo-server || true

(crontab -l 2>/dev/null; echo "* * * * * /vagrant/rotate_echo.sh $NODE_NAME") | crontab -
