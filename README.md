bullfrog-system: STEEM System Configuration Tools
================================

The ***bullfrog-system*** project creates a clean, complete, and standardized installation of the STEEM Daemon suite on Ubuntu 16. It provides all the tools necessary out-of-the-box to mine, witness, and bot against the STEEM blockchain.

Installation
------------
The target system must be a freshly installed Ubuntu 16.04 system. Only OEM 16.04 systems are supported.

Installation is as simple as one command:
> curl https://raw.githubusercontent.com/roylaurie/bullfrog-system/master/install-frog.bash | bash

What it does
------------

The installation script configures the system as such:
* A new user, 'frog' will be created which you will use for all steem maintenance tasks.
* steemd and cli_wallet -d will be installed as system services, out of /var/local/steemd and /var/local/steemwallet
* Users 'steemd' and 'steemwd' will be created to run steemd and cli_wallet -d respectively.
* Management tools will be installed in /home/frog/bin

Running the steemd service
----------------------------
To start/stop/monitor the steemd service:
> sudo service steemd start<br>
> sudo service steemd stop<br>
> sudo service steemd status<br>

To enable/disable steemd starting on boot:
> sudo systemctl enable steemd.service<br>
> sudo systemctl disable steemd.service<br>

Running the steemwalletd service
----------------------------------
To start/stop/monitor the steemd service:
> sudo service steemwalletd start<br>
> sudo service steemwalletd stop<br>
> sudo service steemwalletd status<br>

To enable/disable steemd starting on boot:
> sudo systemctl enable steemd.service<br>
> sudo systemctl disable steemd.service<br>

Management tools
------------------

***bin/config-steemd <config name>***

Switches between pre-existing config.ini files. Default names available: miner, witness, and synconly.

***replay-steemd***

Switches into synconly mode and runs steemd --replay

***recompile-steemd***

Re-clones the steemit source-code, recompiles, and re-installs.
