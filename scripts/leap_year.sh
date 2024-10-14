#!/bin/bash
# This script checks whether a year is a leap year or not

echo "Type the year you want to check (4 digits), followed by [ENTER]:"

read year

if ((("$year" % 400) == "0")) || ((("$year" % 4 == "0") && ("$year" % 100 != "0"))); then
	echo "$year is a leap year"
else
	echo "$year is not a leap year"
fi
