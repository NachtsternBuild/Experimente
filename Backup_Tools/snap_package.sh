#! /bin/bash

while IFS= read -r package; do
	if [ -n "$package" ]; then
		echo "Installieren..."
		sudo snap install "$package"
	fi
done < snap_packages.list
