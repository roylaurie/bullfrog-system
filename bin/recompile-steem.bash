#!/bin/bash

sudo service steemd stop

mkdir -p /home/frog/project/steemit
cd /home/frog/project/steemit

rm -rf last.steem

if [ -d steem ]; then 
	mv steem last.steem
fi

git clone https://github.com/steemit/steem.git

cd steem

git submodule update --init --recursive

cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_CONTENT_PATCHING=OFF -DLOW_MEMORY_NODE=ON .
make
sudo make install

sudo /home/frog/bin/frog/config-steemd.bash synconly

exit 0
