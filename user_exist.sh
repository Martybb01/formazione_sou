#!/bin/bash
# This script checks whether a user exists in MacOs system

clear

echo "This script will check if the user exists in the system"
echo "======================================================="

USER_NAME=$1

if [ -z $USER_NAME ]; then
  echo "Please provide a username as an argument"
  exit 1
fi

if dscl . list /Users | grep -qw "$USER_NAME"; then
  echo "The user $USER_NAME exists in the system"
else
  echo "The user $USER_NAME does not exist in the system"
fi
