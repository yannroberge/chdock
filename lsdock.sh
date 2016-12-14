#!/bin/bash

# Command howtouse will display help
howtouse() { echo "Valid options: $0 -[a|f]"; exit 1; }

#Get plist files from PlistBuddy
getFiles() {
	# Path to PlistBuddy dependancy
	declare PlistBuddy
	PlistBuddy='/usr/libexec/PlistBuddy'

	# Path to Plist storing the Dock data
	declare DOCKFILEPATH
	DOCKFILEPATH="$HOME/Library/Preferences/com.apple.dock.plist"

	i=0
	# $DOCKSCOPE$1:tile-data:file-data:_CFURLString represents the file name location in the Plist
	# $1 is the dock scope (apps or files)
	# $i is the dock index of the file name
	while $PlistBuddy $DOCKFILEPATH -c "Print $1$i:tile-data:file-data:_CFURLString" 2>/dev/null >> .dock.tmp
	do
	((i++))
	done
}

# List dock apps, dock files, or both
DOCKSCOPE=''
APPS=':persistent-apps:'
FILES=':persistent-others:'

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
if [[ $OPTSTRING =~ 'a' ]] || [ "$OPTSTRING" == '' ]
then
	getFiles $APPS
fi
if [[ $OPTSTRING =~ 'f' ]] || [ "$OPTSTRING" == '' ]
then
	getFiles $FILES
fi

# Pass the dock file names from file to a string
DOCKCONTENTS=`cat .dock.tmp`
rm .dock.tmp

# Replace "%20s" by escaped spaces " "
DOCKCONTENTS=`./fixSpaces.pl $DOCKCONTENTS`

# Remove the ASCII encoding (for example, "%5E"s are replaced by "^")
# This allows for file names with non-alphanumeric characters
DOCKCONTENTS=`./asciiDecode.py $DOCKCONTENTS`

# Print the paths neatly
./printFormatted.pl $DOCKCONTENTS | cut -c 8-
exit 0
