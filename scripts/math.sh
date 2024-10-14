#!/bin/bash
# this script calculate the average of a series of numbers.

SCORE="0"
AVERAGE="0"
SUM="0"
NUM="0"

while true; do
	echo -n "Enter your score [0-100%] ('q' to quit): "; read SCORE

	if (("$SCORE" < "0"))  || (("$SCORE" > "100")); then
		echo "No Way! try again: ";
	elif [ "$SCORE" == "q" ]; then
		echo "Average rating: $AVERAGE%."
		break
	else
		SUM=$[$SUM + $SCORE]
		NUM=$[$NUM + 1]
		AVERAGE=$[$SUM / $NUM]
	fi
done

echo "Bye!"
