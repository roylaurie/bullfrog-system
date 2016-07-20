#!/bin/bash
set -xoue pipefail
IFS=$'${NC}\n\t'

#+--------------------------------------+--------------------------------------+
GRN='\033[1;32m'
echo -e "${GRN}+----------------------------------bullfrog-----------------------------------+${NC}\n"
echo -e "${GRN}+-----------------------------------system------------------------------------+${NC}\n"
echo -e "${GRN}|                                                                             |${NC}\n"

echo -e "${GRN}|=== Updating system packages ...                                             |${NC}\n"
sudo apt-get update
sudo apt-get upgrade -y

echo -e "${GRN}|=== Updating system packates ...                                             |${NC}\n"
sudo apt-get install boost cmake git openssl autoconf automake qt5 ncurses readline doxygen\
 ncurses-dev graphviz readline libreadline-dev doxygen ncurses-dev graphviz libreadline6\
 libreadline6-dev libgmp-dev zip unzip nodejs

echo -e "${GRN}|=== Creating user 'frog' ...                                                 |${NC}\n"
sudo adduser frog

echo -e "${GRN}|=== Logging in as user 'frog' ...                                            |${NC}\n"
sudo su frog

echo -e "${GRN}|=== Cloning 'bullfrog-system' project ...                                    |${NC}\n"
mkdir -p /home/frog/project
cd /home/frog/project
git clone https://github.com/roylaurie/bullfrog-system.git

echo -e "${GRN}|=== Restricting file permissions in home dir ...                             |${NC}\n"
chown -R frog:frog /home/frog
chmod -R o-rwx /home/frog

echo -e "${GRN}|=== Logging out as 'frog' ...                                                |${NC}\n"
exit # frog

echo -e "${GRN}|=== Configuring system service 'STEEM DAEMON' ...                            |${NC}\n"
sudo cp /home/frog/project/bullfrog-system/fs/etc/systemd/system/steemd.service /etc/systemd/system
sudo chown root:root /etc/systemd/system/steemd.service
sudo systemctl daemon-reload


echo -e "${GRN}|=== Building STEEM project ...                                               |${NC}\n"
sudo /home/frog/project/bullfrog-system/bin/recompile-steem.bash

echo -e "${GRN}|=== Configuring steemd for 'synconly' ...                                    |${NC}\n"
sudo /home/frog/project/bullfrog-system/bin/config-steemd.bash synconly

echo -e "${GRN}|=== Downloading snapshot of steemd blockchain database ...                   |${NC}\n"
# TODO
echo -e "${GRN}|=== Importing snapshot of steemd blockchain database ...                     |${NC}\n"
# TODO

echo -e "${GRN}|=== Installation complete. Starting replay. Once complete:                   |${NC}\n"
echo -e "${GRN}|       * CTL+C to kill steemd.                                               |${NC}\n"
echo -e "${GRN}|       * Configure files in /usr/local/var/lib/steemd/configs.               |${NC}\n"
echo -e "${GRN}|       * sudo /home/bullfrog/project/bullfrog-system/bin/config-steemd.bash. |${NC}\n"
echo -e "${GRN}|       * sudo service steemd start                                           |${NC}\n"
echo -e "${GRN}|                                                                             |${NC}\n"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}\n"
echo -e "${GRN}+---------------------------installation-complete-----------------------------+${NC}\n"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}\n"

echo -e "${GRN}|=== Replaying imported database in steemd  ...                              |${NC}\n"
sudo /home/frog/project/bullfrog/bin/replay.bash

exit 0
