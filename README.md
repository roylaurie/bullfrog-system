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
* steemd and cli_wallet -d will be installed as system services, out of /var/local/steemd and /var/local/steemwalletd
* Users 'steemd' and 'steemwalletd' will be created to run steemd and cli_wallet -d respectively.
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

To follow the log:
> sudo journalctl -u steemd.service -f

Running the steemwalletd service
----------------------------------
To start/stop/monitor the steemd service:
> sudo service steemwalletd start<br>
> sudo service steemwalletd stop<br>
> sudo service steemwalletd status<br>

To enable/disable steemd starting on boot:
> sudo systemctl enable steemd.service<br>
> sudo systemctl disable steemd.service<br>

To follow the log:
> sudo journalctl -u steemwalletd.service -f

Management tools
------------------

***bin/config-steemd.bash <config name>***

Switches between pre-existing config.ini files. Default names available: miner, witness, and synconly.

***bin/replay-steemd.bash***

Switches into synconly mode and runs steemd --replay

***bin/recompile-steemd.bash***

Re-clones the steemit source-code, recompiles, and re-installs.

How to handle a Hard Fork
-------------------------
First, SSH into your machine with your login user. Then ...

> sudo su frog # maintenance account
> cd  # /home/frog
> sudo service steemd stop
> sudo ~/bin/recompile-steemd.bash  # will restart steemd manually in synconly when done

You'll see the steemd log as it replays the database then syncs. Once sync'd completely, CTL-C to kill steemd. Then ...
> sudo ~/bin/config-steemd.bash miner
> sudo service steemd start

License
-------

