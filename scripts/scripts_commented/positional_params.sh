#!/bin/bash

# Call this script with at least 10 parameters, for example
# ./scriptname 1 2 3 4 5 6 7 8 9 10

# var
MINPARAMS=10

# echo without anything is just a new line
echo 

# $0 is the script name
echo "The name of this script is \"$0\"."
# Adds ./ for the current directory
echo "The name of this script is \"`basename $0`\"."
# Strips out path name info

echo

# if else statement that prints out the params if they are not empty
if [ -n "$1" ]              # Tested variable is quoted.
then
  echo "Parameter #1 is $1"  # Need quotes to escape #
fi

if [ -n "$2" ]
then
  echo "Parameter #2 is $2"
fi

if [ -n "$3" ]
then
  echo "Parameter #3 is $3"
fi

if [ -n "$4" ]
then
  echo "Parameter #4 is $4"
fi

# ...

if [ -n "${10}" ]  # Parameters > $9 must be enclosed in {brackets}.
then
  echo "Parameter #10 is ${10}"
fi

echo "-----------------------------------"
echo "All the command-line parameters are: "$*"" 
# $* is all the command-line parameters

# $# is the number of command-line parameters that has to be at least 10 (-lt is less than)
if [ $# -lt "$MINPARAMS" ]
then
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!"
fi

echo

exit 0

