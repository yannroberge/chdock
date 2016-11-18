#!/bin/bash

# Path to PlistBuddy dependancy
declare PlistBuddy
PlistBuddy='/usr/libexec/PlistBuddy'

# Path to Plist storing the Dock data
declare DOCKFILEPATH
DOCKFILEPATH="$HOME/Library/Preferences/com.apple.dock.plist"

#Get files kept in the Dock

touch dock.tmp
$PlistBuddy $DOCKFILEPATH << Exit > dock.tmp
Print ":persistent-others:" dict
Exit

for i in `cat dock.tmp`
do
	FILTRE=`echo $i | egrep 'file:///.'`
	if [ -n "$FILTRE" ]
	then
		DOCKCONTENTS+="$FILTRE "
	fi
done
rm dock.tmp

for i in $DOCKCONTENTS
do
	echo $i | cut -c 8-
done

#echo "$DOCKCONTENTS" | cut -c 7-
# | cut 

#rm dock.tmp

	#Print ":persistent-others:$INDEX" dict
	# Exit
#echo $FILEAT_IDX_I
# done

#DOCKCONTENT=$($PlistBuddy $DOCKFILEPATH << Exit
#echo "$DOCKCONTENT"
#echo -e ""
#)
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo $DIR
#exit

# sleep 5
# /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.dock.plist << Exit
# Delete :persistent-others:1 dict
# Save
# Exit
# killall Dock
