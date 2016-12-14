#!/bin/bash

# Options planned for the future:
# 	-i -> remove by index
#	-n -> don't restart the Dock.app after remove is done
#	-a -> indexes in apps
#	-f -> indexes in files

# known thing to be fixed: launching the command with no -a nor -f defaults to -a, therefore the command will not search for files by default

# Command howtouse will display help
howtouse() { echo "Valid options: $0 [-a|f] [-i] file|index"; exit 1; }
nooptions() { echo 'rmdock is used with a file path, or an index with -i'; howtouse; }

# if [ : ] #[ $# -eq 1 ] && [ "$(echo $1 | grep -E "^-")" == '' ]
# then
# 	DOCKSCOPE=':'
# else
if [ $# -eq 0 ]
then
	nooptions
fi

OPTSTRING=''
while getopts ":i:fan" OPTIONS
do
	case $OPTIONS in
		'a'|'f'|'i'|'n')
			OPTSTRING+="$OPTIONS";;
		:)
			# If no index specified with -i, use 0 as default (leftmost dock element)
			OPTSTRING+='i'
			REMOVEINDEX='0';;
		'?')
			howtouse;;
	esac
done

# Number of apps and files to be removed
declare napps nfiles
napps=0; nfiles=0

# Store the index of apps and files to be removed
declare -a REMOVEAPPINDEX REMOVEFILEINDEX

# With option -i, get all remove indexes
if [[ $OPTSTRING =~ .*i.* ]]
then
	for i in `seq 1 $#`
	do
		if [[ "$1" =~ ^[0-9]+$ ]]
		then
			if [[ $OPTSTRING =~ .*f.* ]] && ! [[ $OPTSTRING =~ .*a.* ]]
			then
				REMOVEFILEINDEX[$i]="$1"
			else
				REMOVEAPPINDEX[$i]="$1"
			fi
		fi
		shift
	done
# Without option -i, search for the specified files
else
	# Find indexes of apps and files to remove
	for i in `seq 1 $#`
	do
		# Things like "-i" are not searched for
		if ! [[ "$1" =~ ^-["$OPTSTRING"]+$ ]]
	 	then
	 		# Try to find it in the left part of the dock (apps)
	 		APPINDEX=$(./dockindex.sh -a "$1")
	 		if [ "$APPINDEX" != '-1' ]
	 		then
	 			REMOVEAPPINDEX[$napps]="$APPINDEX"
	 			((napps++))
	 		else
	 			# Try to find it in the right part of the dock (files)
	 			FILEINDEX=$(./dockindex.sh -f "$1")
	 			if [ "$FILEINDEX" != '-1' ]
	 			then
	 				REMOVEFILEINDEX[$nfiles]="$FILEINDEX"
	 				((nfiles++))
	 			fi
	 		fi
	 		#REMOVEINDEX[$i]=$(./dockindex.sh -a $getindexopts "$1" )
	 	fi
	 	shift
	done
fi

# Indexes to remove at
# echo ${REMOVEAPPINDEX[*]}
# echo ${REMOVEFILEINDEX[*]}
# exit 0

# Sort indexes in decreasing order
# This ensures items are removed at the correct index
# Example of what happens without backwards sorting: 
# 	./rmdock.sh -i 0 1
# 	-deletes first item (index 0)
# 	-this shifts all remaining item index to the left by 1
# 	-deletes item at new index 1
# 	-problem: when the command was called, that item was actually at index 2 :S
# Note that files indexes are sorted further down, after apps have been removed,
# the reason being that this way, with the rmdock running wihout -a and -f (over 
# the whole dock), indexes that aren't deleted in apps get a shot at being deleted
# from files.
SORTEDAPPINDEX=$(echo ${REMOVEAPPINDEX[*]} | tr ' ' "\n"| sort -nr | tr "\n" ' ')
#echo $SORTEDAPPINDEX
#exit 0

# Path to PlistBuddy dependancy
declare PlistBuddy
PlistBuddy='/usr/libexec/PlistBuddy'

# Path to Plist storing the Dock data
declare DOCKFILEPATH
DOCKFILEPATH="$HOME/Library/Preferences/com.apple.dock.plist"

#Remove items at specified indexes
MAXAPPINDEX=0
for i in $SORTEDAPPINDEX
do
	"$PlistBuddy" -c "Delete :persistent-apps:$i dict" "$DOCKFILEPATH" || if [ "$?" == '1' ]
		# If an index is not found, try to delete it in files
		then
			# Find out how far apps go
			if [ "$MAXAPPINDEX" == '0' ]
			then
				while "$PlistBuddy" -c "Print :persistent-apps:$MAXAPPINDEX:GUID" "$DOCKFILEPATH" >> /dev/null
				do
					((MAXAPPINDEX++))
				done
				if [ "$MAXAPPINDEX" -ge 1 ]; then ((MAXAPPINDEX--)); fi
				# echo $MAXAPPINDEX
				# exit
			fi
			# Add the index not found in apps to those to look for in files
			((nfiles++))
			((REMOVEFILEINDEX["$nfiles"]="$i-($MAXAPPINDEX+1)"))
			# echo "${REMOVEFILEINDEX[$nfiles]}"
			# exit
		fi
done

SORTEDFILEINDEX=$(echo ${REMOVEFILEINDEX[*]} | tr ' ' "\n"| sort -nr | tr "\n" ' ')

for i in $SORTEDFILEINDEX
do
	"$PlistBuddy" -c "Delete :persistent-others:$i dict" "$DOCKFILEPATH"
done

# Option -n inhibits final restart
if ! [[ "$OPTSTRING" =~ .*n.* ]]
then
	killall Dock
fi
exit 0
