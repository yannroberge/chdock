#!/bin/bash

# Path to PlistBuddy dependancy
declare PlistBuddy
PlistBuddy='/usr/libexec/PlistBuddy'

# Path to Plist storing the Dock data
declare DOCKFILEPATH
DOCKFILEPATH="$HOME/Library/Preferences/com.apple.dock.plist"

#Get plist content from PlistBuddy (atrociously messy)
touch .dock.tmp
$PlistBuddy $DOCKFILEPATH << Exit > .dock.tmp
Print ":persistent-others:" dict
Exit

#Filter its output
for i in `cat .dock.tmp`
do
	FILTRE=`echo $i | egrep 'file:///.'`
	if [ -n "$FILTRE" ]
	then
		DOCKCONTENTS+="$FILTRE "
	fi
done
rm .dock.tmp

#Print the paths neatly
for i in $DOCKCONTENTS
do
	echo $i | cut -c 8-
done
