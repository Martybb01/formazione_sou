#!/bin/bash
# This script displays the file information

echo "This script will display file infos"
echo "==================================="

if [ $# -ne 1 ]; then
  echo "Usage: $0 filename"
  exit 1
fi

FILE=$1

echo "Properties for $FILE:"

if [[ -f $FILE ]]; then
  echo "Size is $(ls -lh $FILE | awk '{ print $5 }')"
  echo "Type is $(file $FILE | cut -d":" -f2 -)"
  echo "Inode number is $(ls -i $FILE | cut -d" " -f1 -)"
  echo "$(df -h $FILE | grep -v Mounted | awk '{ print "On",$1", \
  which is mounted as the", $6 ,"partition."}')"
else
	  echo "File does not exist."
fi
