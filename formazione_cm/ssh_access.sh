#!/bin/bash

CONTAINER_PORT_DOCKER=4202

# Decrypt file key
ansible-vault decrypt ./id_key_genuser --vault-password-file ./vault_pwd

# SSH to remote server
ssh -i ./id_key_genuser -p $CONTAINER_PORT_DOCKER genuser@127.0.0.1
# ansible-playbook -i inventory deploy_containers.yml --vault-password-file ./vault_pwd -vvv

# Encrypt file key again
ansible-vault encrypt ./id_key_genuser --vault-password-file ./vault_pwd
