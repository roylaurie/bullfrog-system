#!/bin/bash

echo -n "Type 'yes' to continue: "
read YES
if [ "${YES}" != "yes" ]; then
	exit 1
fi

sudo deluser frog
sudo deluser steemd
sudo deluser steemwalletd

sudo rm -rf /home/frog
sudo rm -rf /var/local/steemd
sudo rm -rf /var/local/steemwalletd

echo "done"
exit 0
