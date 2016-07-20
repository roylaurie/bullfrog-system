#!/bin/bash

sudo service steemd stop

cd /home/frog/project/steemit

rm -rf last.steem
mv steem last.steem

git clone https://github.com/steemit/steem.git

cd steem

git submodule update --init --recursive

cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_CONTENT_PATCHING=OFF -DLOW_MEMORY_NODE=ON .
make
sudo make install

sudo /home/frog/bin/config-steemd.bash synconly

exit 0
