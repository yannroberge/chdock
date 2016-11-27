#!/bin/bash

howtouse() { echo "Valid options: $0 -[a|f]"; exit 1; }
# Path to PlistBuddy dependancy
declare PlistBuddy
PlistBuddy='/usr/libexec/PlistBuddy'

# List dock apps, dock files, or both
DOCKSCOPE=''
if [ $# -eq 0 ] || [ "$(echo $1 | grep -E "^-")" == '' ]
then
	DOCKSCOPE=':'
else
	OPTSTRING=''
	while getopts ":fa" OPTIONS
	do
		case $OPTIONS in
			 'a'|'f')
				OPTSTRING+="$OPTIONS";;
			'?')
				howtouse;;
		esac
	done

	if [[ $OPTSTRING =~ [af][af] ]]
	then
		DOCKSCOPE=':'
	elif [[ "$OPTSTRING" == a ]]
	then
		DOCKSCOPE=':persistent-apps:'
	elif [[ "$OPTSTRING" == f ]]
	then
		DOCKSCOPE=':persistent-others:'
	fi
fi

# Path to Plist storing the Dock data
declare DOCKFILEPATH
DOCKFILEPATH="$HOME/Library/Preferences/com.apple.dock.plist"

#Get plist content from PlistBuddy (atrociously messy)
touch .dock.tmp
$PlistBuddy $DOCKFILEPATH << Exit >> .dock.tmp
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
