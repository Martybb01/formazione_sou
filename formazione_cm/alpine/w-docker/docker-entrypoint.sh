#!/bin/sh
set -e
# Regenerate ssh key
ssh-keygen -A

# Create the directories
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi

if [ ! -d "/root/.ssh" ]; then
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
fi

# Start the SSH service
/usr/sbin/sshd -D &
# Start the Docker service
echo "${AUTHORIZED_KEYS:-}" > /root/.ssh/authorized_keys
mkdir -p /root/.docker/ && echo ${DOCKER_CONFIG_JSON:-} > /root/.docker/config.json
exec dockerd -H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock
