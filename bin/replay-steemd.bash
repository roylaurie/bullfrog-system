#!/bin/bash
set -oue pipefail
IFS=$'\n\t'

sudo service steemd stop
sudo /home/frog/bin/config-steemd.bash synconly

cd /var/local/steemd
sudo su -u steemd steemd --replay

exit 0
