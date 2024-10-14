#!/bin/bash
# this script displays path to homedir, the terminal type and list of running services

clear

echo "This script will give us environment information"
echo

echo "This is homedir: $HOME"
echo

echo "This is terminal type: $TERM"
echo

echo "This is list of services: "
launchctl list
echo
