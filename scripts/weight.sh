#!/bin/bash
# This script prints the weight of a person, given the height and weight as arguments

echo "This script will calculate the weight of a person, given the height and weight"
echo "==============================================================================="

if [ $# -ne 2 ]; then
  echo "Please provide the height and weight as arguments"
  exit 1
fi

height=$1
weight=$2
ideal_weight=$((height - 110))

if [ $weight -eq $ideal_weight ]; then
  echo "The weight is ideal"
elif [ $weight -gt $ideal_weight ]; then
  echo "The weight is above the ideal"
else
  echo "The weight is below the ideal"
fi
