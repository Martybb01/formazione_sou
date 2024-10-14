#!/bin/bash
# am-i-root.sh:   Am I root or not?

ROOT_UID=0         # Root has $UID 0.

# $UID if u are root will be 0 so if $UID is equal to $ROOT_UID then you are root
if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "You are root."
else
  echo "You are just an ordinary user (but mom loves you just the same)."
fi

exit 0

# ============================================================= #
# Code below will not execute, because the script already exited.

# An alternate method of getting to the root of matters:

ROOTUSER_NAME=root
username=`id -nu`   # or username=`whoami` or username=$USER

if [ "$username" = "$ROOTUSER_NAME" ]
then
  echo "Rooty, toot, toot. You are root."
else
  echo "You are just a regular fella."
fi
