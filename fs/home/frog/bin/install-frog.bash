#!/bin/bash
set -x

sudo adduser frog
sudo su frog

mkdir -p /home/frog/project/roylaurie
cd /home/frog/project/roylaurie
git clone https://github.com/roylaurie/bullfrog-system.git

chown -R frog:frog /home/frog
chmod -R o-rwx /home/frog

exit # sudo su frog


