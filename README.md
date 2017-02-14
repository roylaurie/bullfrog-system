bullfrog-system: STEEM System Configuration Tools
================================

The ***bullfrog-system*** project creates a clean, complete, and standardized installation of the STEEM Daemon suite on Ubuntu 16. It provides all the tools necessary out-of-the-box to mine, witness, and bot against the STEEM blockchain.

STEEM Tutorial: [project: bullfrog-system | Mine STEEM with ease](https://steemit.com/steemit/@kilrathi/project-bullfrog-system)

Installation
------------
The target system must be a freshly installed Ubuntu 16.04 system. Only "OEM" 16.04 systems are supported.

Installation is as simple as one command:
> curl https://raw.githubusercontent.com/roylaurie/bullfrog-system/master/install-frog.bash | bash

![screenshot](https://steemitimages.com/0x0/https://www.steemimg.com/images/2016/07/21/install-screenshot6351e.png)

What it does
------------

The installation script configures the system as such:
* A new user, 'frog' will be created which you will use for all steem maintenance tasks.
* steemd and cli_wallet -d will be installed as system services, out of /var/local/steemd and /var/local/steemwalletd
* Users 'steemd' and 'steemwalletd' will be created to run steemd and cli_wallet -d respectively.
* Management tools will be installed in /home/frog/bin
* steemd will automatically start on boot.
* steemd will immediately begin running --replay and sync after install.

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

***bin/frog/config-steemd.bash <config name>***

Switches between pre-existing config.ini files. Default names available: miner, witness, and synconly.

***bin/frog/replay-steemd.bash***

Switches into synconly mode and runs steemd --replay

***bin/frog/recompile-steem.bash***

Re-clones the steemit source-code, recompiles, and re-installs.

How to handle a Hard Fork
-------------------------
First, SSH into your machine with your login user. Then ...

> sudo su frog # maintenance account<br>
> cd  # /home/frog<br>
> sudo service steemd stop<br>
> sudo ~/bin/frog/recompile-steemd.bash  # will run replay automatically

You'll see the steemd log as it replays the database then syncs. Once sync'd completely, CTL-C to kill steemd. Then ...
> sudo ~/bin/frog/config-steemd.bash miner<br>
> sudo service steemd start

License (MIT)
-------------
Copyright (c) 2016 Roy Laurie

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
