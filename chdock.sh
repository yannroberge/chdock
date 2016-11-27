#!/bin/bash

# Options planned for the future:
# 	-v -> verbose
#	-l -> list (Functional :) )
#	-a -> scope in apps
#	-f -> scope in files
#	-e -> execute [position in Dock]
#	-r -> remove [position in Dock]
#	-s -> search (returns position in dock, or "File(s) not found in Dock")

# Command howtouse will display help
howtouse() { echo "Valid options: $0 -[v|l|a|f|e|r|s]"; exit 1; }
nooptions() { echo 'chdock is used with options'; howtouse; }

# Condition left of "||": If no parameters at all are passed
# Condition right of "||": If none of the parameters start with a hyphen '-'
#if [ $# -eq 0 ] || [ "$(for i in `echo $@`; do echo $i | grep -E "^-"; done)" == '' ]

# Verify chdock wasn't called without option
# Condition left of "||": If no parameters at all are passed
# Condition right of "||": If the first parameter doesn't start with a hyphen '-' (getopts only accepts options if the first parameter is an option itself)
if [ $# -eq 0 ] || [ "$(echo $1 | grep -E "^-")" == '' ]
then
	nooptions
fi

# Call the appropriate scripts depending on the options used
OPTSTRING=''
while getopts ":vlafers" OPTIONS
do
	case $OPTIONS in
		 'l'|'a'|'f')
			OPTSTRING+="$OPTIONS";;
		'?')
			howtouse;;
		*)
			echo "I haven't programmed in the -$OPTIONS option yet :S"
			exit ;;
	esac
done

if [[ "$OPTSTRING" =~ .*l.* ]]
then
	if [[ $OPTSTRING == l ]] || [[ $OPTSTRING =~ .*[af].*[af].* ]]
	then
		./lsdock.sh
	elif [[ "$OPTSTRING" =~ .*a.* ]]
	then
		./lsdock.sh -a
	elif [[ "$OPTSTRING" =~ .*f.* ]]
	then
		./lsdock.sh -f
	fi
else
	echo "Did you mean: "
	echo "   $0 -la (list dock apps)"
	echo "   $0 -lf (list dock files)"
	echo "   $0 -laf (list dock apps and files)"
	#echo "Options -a and -f are used with -l to list either dock apps or dock files (to the right of the vertical bar in the dock)"
fi

exit