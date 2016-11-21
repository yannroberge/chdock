#!/bin/bash

# Path to PlistBuddy dependancy
declare PlistBuddy
PlistBuddy='/usr/libexec/PlistBuddy'

# List dock apps, dock files, or both
#DOCKSCOPE=':persistent-apps:'
#DOCKSCOPE=':persistent-others:'
DOCKSCOPE=':'

# Path to Plist storing the Dock data
declare DOCKFILEPATH
DOCKFILEPATH="$HOME/Library/Preferences/com.apple.dock.plist"

#Get plist content from PlistBuddy (atrociously messy)
touch .dock.tmp
$PlistBuddy $DOCKFILEPATH << Exit > .dock.tmp
Print "$DOCKSCOPE" dict
Exit

# Filter its output
for i in `cat .dock.tmp`
do
	FILTRE=`echo $i | egrep 'file:///.'`
	if [ -n "$FILTRE" ]
	then
		DOCKCONTENTS+="$FILTRE "
	fi
done
rm .dock.tmp

# Replace "%20s" by escaped spaces "\ "
DOCKCONTENTS=`./fixSpaces.pl $DOCKCONTENTS`

# Remove the ASCII encoding (for example, "%5E"s are replaced by "^")
DOCKCONTENTS=`./asciiDecode.py $DOCKCONTENTS`

# Print the paths neatly
./printFormatted.pl $DOCKCONTENTS | cut -c 8-
