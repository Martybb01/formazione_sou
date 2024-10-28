#!/bin/bash

NODE_NAME=$1

if [ "$NODE_NAME" == "node1" ]; then
  OTHER_NODE_IP="192.168.56.11"
else
  OTHER_NODE_IP="192.168.56.10"
fi

CURRENT_MINUTE=$(date +"%M")

# Se il minuto corrente è pari, attiva il container sul node1
# Se il minuto corrente è dispari, attiva il container sul node2
if (( CURRENT_MINUTE % 2 == 0 )); then
  if [ "$NODE_NAME" == "node1" ]; then
    docker start echo-server || docker run -d --name echo-server -p 8080:80 ealen/echo-server
  else
    docker stop echo-server
  fi
else
  if [ "$NODE_NAME" == "node2" ]; then
    docker start echo-server || docker run -d --name echo-server -p 8080:80 ealen/echo-server
  else
    docker stop echo-server
  fi
fi
