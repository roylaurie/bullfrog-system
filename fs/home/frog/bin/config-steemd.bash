#!/bin/bash

STEEMD_WORKING_DIR='/usr/local/var/lib/steemd'

CONFIGNAME="$1"
CONFIGPATH="$(realpath $STEEMD_WORKING_DIR/configs/config.$CONFIGNAME.ini)"

if [ ! -f $CONFIGPATH ]; then
	echo "config-steemd.bash: error: Invalid config name."
	ls $STEEMD_WORKING_DIR/configs
	exit 1
fi

cd $STEEMD_WORKING_DIR
rm -f config.ini
ln -s configs/config.$CONFIGNAME.ini config.ini
chown steemd:steemd config.ini

exit 0
