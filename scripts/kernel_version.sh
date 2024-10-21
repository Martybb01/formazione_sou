#!/bin/bash

# Check if the kernel version running is the latest one

# current_kernel=$(uname -r)

# latest_kernel=$(rpm -q kernel | sed 's/kernel-//g' | tail -n 1)

# if [ "$current_kernel" == "$latest_kernel" ]; then
# 	echo "TRUE"
# else
# 	echo "FALSE"
# fi

# exit 0

#------------------------------------------
# made this script universal for Debian based also

current_kernel=$(uname -r)
echo "Current Kernel: $current_kernel"

os_release=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
echo "OS Release: $os_release"

get_latest_kernel() {
	if [ "$os_release" == "rhel" ] || [ "$os_release" == "fedora" ] || [ "$os_release" == "centos" ]; then
		latest_kernel=$(rpm -q kernel | sed 's/kernel-//' | tail -n 1)
	elif [ "$os_release" == "debian" ] || [ "$os_release" == "ubuntu" ]; then
		latest_kernel=$(dpkg -l | grep 'linux-image' | sed 's/linux-image-//' | awk '{print $2}' | head -n 1)
	else
		echo "Unsupported OS"
		exit 1
	fi
	echo "Latest Kernel: $latest_kernel"
}

get_latest_kernel

if [ "$current_kernel" == "$latest_kernel" ]; then
	echo "TRUE"
else
	echo "FALSE"
fi

exit 0





