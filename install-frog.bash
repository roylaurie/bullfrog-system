#!/bin/bash
set -oue pipefail
IFS=$'\n\t'

GRN='\033[1;32m'
NC='\033[0m' 
echo -e "${GRN}+----------------------------------bullfrog-----------------------------------+${NC}"
echo -e "${GRN}+-----------------------------------system------------------------------------+${NC}"
echo -e "${GRN}|                                                                             |${NC}"

echo -e "${GRN}|=== Updating system packages ...                                             |${NC}"
sudo apt-get update
sudo apt-get upgrade -y

echo -e "${GRN}|=== Installing required system packages ...                                 |${NC}"
sudo apt-get install gcc g++ libboost-all-dev cmake autoconf automake qt5-default\
 qttools5-dev-tools doxygen libncurses5-dev libncurses5 graphviz libreadline6\
 libreadline6-dev libgmp-dev zip unzip nodejs python3 vim sysstat

echo -e "${GRN}|=== Creating user 'frog' ...                                                 |${NC}"
sudo adduser frog

echo -e "${GRN}|=== Logging in as user 'frog' ...                                            |${NC}"
sudo su frog

echo -e "${GRN}|=== Cloning 'bullfrog-system' project ...                                    |${NC}"
mkdir -p /home/frog/project
cd /home/frog/project
git clone https://github.com/roylaurie/bullfrog-system.git

echo -e "${GRN}|=== Restricting file permissions in home dir ...                             |${NC}"
chown -R frog:frog /home/frog
chmod -R o-rwx /home/frog

echo -e "${GRN}|=== Logging out as 'frog' ...                                                |${NC}"
exit # frog

echo -e "${GRN}|=== Configuring system service 'STEEM DAEMON' ...                            |${NC}"
sudo cp /home/frog/project/bullfrog-system/fs/etc/systemd/system/steemd.service /etc/systemd/system
sudo chown root:root /etc/systemd/system/steemd.service
sudo systemctl daemon-reload

echo -e "${GRN}|=== Building STEEM project ...                                               |${NC}"
sudo /home/frog/project/bullfrog-system/bin/recompile-steem.bash

echo -e "${GRN}|=== Configuring steemd for 'synconly' ...                                    |${NC}"
sudo /home/frog/project/bullfrog-system/bin/config-steemd.bash synconly

echo -e "${GRN}|=== Downloading snapshot of steemd blockchain database ...                   |${NC}"
# TODO
echo -e "${GRN}|=== Importing snapshot of steemd blockchain database ...                     |${NC}"
# TODO

echo -e "${GRN}|=== Installation complete. Starting replay. Once complete:                   |${NC}"
echo -e "${GRN}|       * CTL+C to kill steemd.                                               |${NC}"
echo -e "${GRN}|       * Configure files in /usr/local/var/lib/steemd/configs.               |${NC}"
echo -e "${GRN}|       * sudo /home/bullfrog/project/bullfrog-system/bin/config-steemd.bash. |${NC}"
echo -e "${GRN}|       * sudo service steemd start                                           |${NC}"
echo -e "${GRN}|                                                                             |${NC}"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo -e "${GRN}+---------------------------installation-complete-----------------------------+${NC}"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo

echo -e "${GRN}|=== Replaying imported database in steemd  ...                              |${NC}"
sudo /home/frog/project/bullfrog/bin/replay.bash

exit 0
