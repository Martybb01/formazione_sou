#!/bin/bash

CONTAINER_PORT_ALPINE=4200
CONTAINER_PORT_ROCKY=4201
CONTAINER_PORT_DOCKER=4202

# Decrypt file key
ansible-vault decrypt ./id_key_genuser --vault-password-file ./vault_pwd

# SSH to remote server
ssh -i ./id_key_genuser -p $CONTAINER_PORT_DOCKER genuser@localhost

# Encrypt file key again
ansible-vault encrypt ./id_key_genuser --vault-password-file ./vault_pwd
