#!/bin/bash
set -oue pipefail
IFS=$'\n\t'

FROG_BIN_DIR='/home/frog/project/bullfrog-system/bin'

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
 libreadline6-dev libgmp-dev zip unzip nodejs python3 vim sysstat libssl-dev

echo -e "${GRN}|=== Creating user 'frog' ...                                                 |${NC}"
sudo adduser --disabled-password --gecos "" frog

echo -e "${GRN}|=== Logging in as user 'frog' ...                                            |${NC}"
sudo su frog
mkdir -p /home/frog/project
mkdir -p /home/frog/wallet/steem


echo -e "${GRN}|=== Cloning 'bullfrog-system' project ...                                    |${NC}"
cd /home/frog/project
git clone https://github.com/roylaurie/bullfrog-system.git
cd /home/frog
ln -s ./project/bullfrog-system/bin .

echo -e "${GRN}|=== Logging out as 'frog' ...                                                |${NC}"
exit # frog


echo -e "${GRN}|=== Creating and configuer user 'steemd' ...                                 |${NC}"
sudo mkdir -p /usr/local/var/lib/steemd /usr/local/var/lib/steemd/backups
sudo cp -R /home/frog/project/bullfrog-system/configs /usr/local/var/lib/steemd
sudo adduser --disabled-login --disabled-password --no-create-dir --home=/usr/local/var/lib/steemd\
 steemd
sudo chown -R steemd:steemd /usr/local/var/lib/steemd
sudo chmod -R o-rwx /usr/local/var/lib/steemd

echo -e "${GRN}|=== Configuring system service 'STEEM Daemon' ...                            |${NC}"
sudo cp /home/frog/project/bullfrog-system/systemd/steemd.service /etc/systemd/system
sudo chown root:root /etc/systemd/system/steemd.service
sudo chmod 644 /etc/systemd/system/steemd.service
sudo systemctl daemon-reload

echo -e "${GRN}|=== Restricting file permissions in 'frog' home dir ...                      |${NC}"
sudo su frog
chown -R frog:frog /home/frog
chmod -R o-rwx /home/frog
exit # frog

echo -e "${GRN}|=== Building STEEM project ...                                               |${NC}"
sudo /home/frog/bin/recompile-steem.bash

echo -e "${GRN}|=== Configuring steemd for 'synconly' ...                                    |${NC}"
sudo /home/frog/bin/config-steemd.bash synconly

echo -e "${GRN}|=== Downloading snapshot of steemd blockchain database ...                   |${NC}"
# TODO
echo -e "${GRN}|=== Importing snapshot of steemd blockchain database ...                     |${NC}"
# TODO import

echo -e "${GRN}|=== Installation complete. Starting replay. Once complete:                   |${NC}"
echo -e "${GRN}|       * CTL-C to kill steemd.                                               |${NC}"
echo -e "${GRN}|       * Configure files in /usr/local/var/lib/steemd/configs.               |${NC}"
echo -e "${GRN}|       * sudo /home/frog/bin/config-steemd.bash.                             |${NC}"
echo -e "${GRN}|       * sudo service steemd start                                           |${NC}"
echo -e "${GRN}|                                                                             |${NC}"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo -e "${GRN}+---------------------------installation-complete-----------------------------+${NC}"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo

echo -e "${GRN}|=== Replaying imported database in steemd  ...                              |${NC}"
sudo /home/frog/project/bullfrog/bin/replay.bash

exit 0
