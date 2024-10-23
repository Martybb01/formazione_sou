#!/bin/bash

# Write a script that makes a copy of each file that has the *.txt extension.
# The copy should be named filename.txt.bak. After making the copy, the script should move it to the /tmp directory.
# While running the script, the directory where it should look for the files should be provided as an argument.
# If no argument was provided, the script should stop with exit code 9.


if [ $# -eq 0 ]; then
	echo "No argument provided"
	exit 9
fi

for file in $1/*.txt; do
	cp $file $file.bak
	mv $file.bak /tmp
	echo "All done!"
done

exit 0
