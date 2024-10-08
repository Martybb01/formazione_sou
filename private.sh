#!/bin/bash
# this script can make any file in dir private

echo "This script will make any file in the directory private"
echo "Enter the file number you want to protect: "

PS3="Your choice: "
QUIT="Quit this program - I feel safe now"
touch "$QUIT"

select FILENAME in *;
do
	case $FILENAME in
		"$QUIT")
		echo "Exiting"
		break
		;;
		*)
		echo "You have chosen $FILENAME ($REPLY)"
		chmod go-rwx "$FILENAME"
		echo "The file $FILENAME is now private"
		;;
	esac
done
rm "$QUIT"
