#!/bin/bash
 
#  verifyvolumes.sh
#  Executes 'diskutil verifyvolume' to verify all mounted volumes on a macOS system.
#
#  by Kirk Coombs (kcoombs@coombscloud.com)
#  Version 1.1 (April 04, 2017)
#    - Fixed hang on error
#  Version 1.0 (April 04, 2017)
#    - Initial release
 
VOLUMES="/Volumes/*"
for DIR in $VOLUMES
do
	VOL=$(echo $DIR | cut -d / -f 3)
	if [ "$VOL" = "Macintosh HD" ]; then
		printf "Performing verify on: \"$VOL\" (System may become unresponsive)\n"
	else
		printf "Performing verify on: \"$VOL\"\n"
	fi
	eval diskutil verifyvolume \'$VOL\' > /tmp/diskutil 2>&1
	if [ $? -eq 0 ]; then
		printf "   \"$VOL\" is clean.\n"
	else
	    printf "   Verify exited with errors:\n"
	    while read LINE
	    do
	    	printf "     $LINE\n"
	    done < /tmp/diskutil
	fi
	rm /tmp/diskutil
done
