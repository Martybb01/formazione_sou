#!/bin/bash

# Cleanup
# Run as root, of course.

# Move to the log directory
cd /var/log

# clears the content of messages and wtmp log files, replacing it with nothing (/dev/null)
cat /dev/null > messages
cat /dev/null > wtmp

# Message to the user
echo "Log files cleaned up."
