#!/bin/bash
set -oue pipefail
IFS=$'\n\t'

sudo service steemd stop
sudo /home/frog/bin/config-steemd.bash synconly

sudo su steemd
cd
steemd --replay

exit 0
