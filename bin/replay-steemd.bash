#!/bin/bash
set -oue pipefail
IFS=$'\n\t'

sudo service steemd stop
sudo /home/frog/bin/frog/config-steemd.bash synconly

cd /var/local/steemd
sudo -u steemd steemd --replay

exit 0
