#!/bin/bash

echo -n "Type 'yes' to continue: "
read YES
if [ "${YES}" != "yes" ]; then
	exit 1
fi

sudo rm -f /etc/systemd/system/steem*
sudo systemctl daemon-reload


sudo deluser --remove-home --remove-all-files --force frog
sudo deluser --remove-home --remove-all-files --force steemd
sudo deluser --remove-home --remove-all-files --force steemwalletd
sudo delgroup --force frog
sudo delgroup --force steemd
sudo delgroup --force steemdwalletd

sudo rm -f /etc/update-motd/00-bullfrog
sudo chmod 755 /etc/update-motd/*

echo "done"
exit 0
