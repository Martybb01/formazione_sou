#!/bin/bash

# Check if the kernel version running is the latest one

current_kernel=$(uname -r)

latest_kernel=$(rpm -q kernel | sed 's/kernel-//g' | tail -n 1)

if [ "$current_kernel" == "$latest_kernel" ]; then
	echo "TRUE"
else
	echo "FALSE"
fi

exit 0

#------------------------------------------
# Other possibilities for finding the running kernel version
# current_kernel=$(hostnamectl | grep "Kernel" | awk '{print $3}')

