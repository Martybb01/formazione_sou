#!/bin/bash
# This script displays a rectangle and its area

clear

height=$1
width=$2

if [ -z "$height" ] || [ -z "$width" ]; then
  echo "Please provide the height and width of the rectangle"
  echo "Usage: $0 <height> <width>"
  exit 1
fi

area=$((($height * $width)/2))

echo "The area of the rectangle is $area"
echo
