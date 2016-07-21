#!/bin/bash
set -oue pipefail
IFS=$'\n\t'

FROG_BIN_DIR='/home/frog/project/bullfrog-system/bin'

GRN='\033[1;32m'
NC='\033[0m' 

echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo -e "${GRN}+----------------------------------bullfrog-----------------------------------+${NC}"
echo -e "${GRN}+-----------------------------------system------------------------------------+${NC}"
echo -e "${GRN}|                                                                             |${NC}"

echo -e "${GRN}|=== Updating system packages ...                                             |${NC}"
sudo apt-get update
sudo apt-get upgrade -y
 
echo -e "${GRN}|=== Installing required system packages ...                                  |${NC}"
sudo apt-get install gcc g++ libboost-all-dev cmake autoconf automake qt5-default\
 qttools5-dev-tools doxygen libncurses5-dev libncurses5 graphviz libreadline6 git\
 libreadline6-dev libgmp-dev zip unzip nodejs python3 vim sysstat libssl-dev build-essential

echo -e "${GRN}|=== Creating user 'frog' ...                                                 |${NC}"
sudo adduser --disabled-password --disabled-login --gecos "" frog || echo "already made user"
sudo usermod -aG sudo frog  || echo "already added user to group"
sudo mkdir -p /home/frog/project  || echo "already added project folder"
sudo mkdir -p /home/frog/wallet/steem  || echo "already made wallet folder"
sudo chown -R frog:frog /home/frog  

echo -e "${GRN}|=== Cloning 'bullfrog-system' project ...                                    |${NC}"
sudo -u frog git clone https://github.com/roylaurie/bullfrog-system.git /home/frog/project/bullfrog-system || sudo rm -rf /home/frog/project/bullfrog-system && git clone https://github.com/roylaurie/bullfrog-system.git /home/frog/project/bullfrog-system
sudo -u frog ln -s /home/frog/project/bullfrog-system/bin
###Where's this creating a link to?

echo -e "${GRN}|=== Creating and configuring user 'steemd' ...                               |${NC}"
sudo mkdir /var/local/steemd
sudo adduser --disabled-login --disabled-password --home=/var/local/steemd --gecos "" steemd || echo "already made user"
sudo cp -R /home/frog/project/bullfrog-system/configs /var/local/steemd 
sudo mkdir -p /var/local/steemd/backups /var/local/steemd/witness_node_data_dir  || echo "folders already there"
sudo chown -R steemd:steemd /var/local/steemd 
sudo chmod -R o-rwx /var/local/steemd

echo -e "${GRN}|=== Creating and configuring user 'steemwd' ...                              |${NC}"
sudo adduser --disabled-login --disabled-password --home=/var/local/steemwallet --gecos "" steemwd || echo "already made user"
sudo mkdir -p /var/local/steemwallet/backups  || echo "already made folder"
sudo chown -R steemwd:steemwd /var/local/steemwallet
sudo chmod -R o-rwx /var/local/steemwallet

echo -e "${GRN}|=== Configuring system services ...                                          |${NC}"
sudo cp /home/frog/project/bullfrog-system/systemd/* /etc/systemd/system
sudo chown root:root /etc/systemd/system/steemd.service
sudo chown root:root /etc/systemd/system/steemwallet.service
sudo chmod 644 /etc/systemd/system/steemd.service
sudo chmod 644 /etc/systemd/system/steemwallet.service
sudo systemctl daemon-reload

echo -e "${GRN}|=== Configuring system service 'STEEM Wallet Daemon' ...                     |${NC}"
sudo cp /home/frog/project/bullfrog-system/systemd/steemd.service /etc/systemd/system
sudo chown root:root /etc/systemd/system/steemd.service
sudo chmod 644 /etc/systemd/system/steemd.service
sudo systemctl daemon-reload

echo -e "${GRN}|=== Restricting file permissions in 'frog' home dir ...                      |${NC}"
sudo chown -R frog:frog /home/frog
sudo chmod -R o-rwx /home/frog

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
echo -e "${GRN}|       * sudo passwd frog                                                    |${NC}"
echo -e "${GRN}|       * Configure files in /usr/local/var/lib/steemd/configs.               |${NC}"
echo -e "${GRN}|       * sudo /home/frog/bin/config-steemd.bash                              |${NC}"
echo -e "${GRN}|       * sudo service steemd start                                           |${NC}"
echo -e "${GRN}|                                                                             |${NC}"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo -e "${GRN}+---------------------------installation-complete-----------------------------+${NC}"
echo -e "${GRN}+-----------------------------------------------------------------------------+${NC}"
echo

echo -e "${GRN}|=== Replaying imported database in steemd  ...                               |${NC}"
sudo /home/frog/bin/replay-steemd.bash

exit 0
