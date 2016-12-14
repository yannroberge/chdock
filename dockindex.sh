#!/bin/bash

# Returns the index of the argument in the dock 
# If not found, its rank is given as '-1' 
# Indexing starts at 0 
# Docks apps come before dock files 
# Finder and the trash do not count as dock elements 
# ex: On a year 2016 out-of-the-box mac, /Application/App Store.app has index 0,
# careless of Finder's presence as the leftmost icon on the dock.  

howtouse() { echo -E "How to use: $0 [-af] /path/to/file..." >&2; exit 1; }

# If no arguments explain how to use
if [ $# -eq 0 ]
then
	howtouse
fi

# Index in dock apps, dock files, or both
OPTSTRING=''
while getopts ":fa" OPTIONS
do
	case "$OPTIONS" in
		 'a'|'f')
			OPTSTRING+="$OPTIONS";;
		'?')
			howtouse;;
	esac
done

# Dock cache file path:
DOCKCACHE='./dockcontent.cache'

# If the dock cache file doesn't exist, create it
touch "$DOCKCACHE"

# Write the dock cache
if [ "$OPTSTRING" == '' ]
then
	./lsdock.sh > "$DOCKCACHE"
else
	./lsdock.sh "-$OPTSTRING" > "$DOCKCACHE"
fi

# if [[ $OPTSTRING =~ [af][af] ]] || [ $OPTSTRING == '' ]
# then
# 	./lsdock.sh -af > "$DOCKCACHE"
# elif [[ "$OPTSTRING" == a ]]
# then
# 	DOCKSCOPE=':persistent-apps:'
# elif [[ "$OPTSTRING" == f ]]
# then
# 	DOCKSCOPE=':persistent-others:'
# fi

# Iterate through the cache with each argument 
# Write indexes found to standard output
count=0
for i in "$@"
do
	# Don't look for any of the options (regexp matches -a, -f, -af or -fa)
	# This still works if called with too many options, like -fafafffaaafa, hence the {1,${#OPTSTRING}} regexp quantifier
	if [[ "$i" =~ ^-[af]{1,${#OPTSTRING}}$ ]]
	then
		continue
	fi

	INDEX=0
	i=`echo $i | perl -p -e 's/\/$//'`
	#echo $i

	# "read -r" reads the dock cache line-by-line, as raw strings (hence option -r), for compatibility with file like $%^éüî\%20.txt
	while read -r j
	do
		j=`echo $j | perl -p -e 's/\/$//'` # UNNECESSARILY REPEATED COMPUTATION HERE SHOULD BE perl'ed directly in $DOCKCACHE
		#echo $j
		if [ "$i" == "$j" ]
		then
			INDEXES["$count"]="$INDEX"
			(( count++ ))
			continue 2 # Break both the while loop and the for loop it's nested in. This saves some computational time.
		fi
		(( INDEX+=1 ))
	done < "$DOCKCACHE"
	
	if [ "${INDEXES["$count"]}" == '' ]
	then
		INDEXES["$count"]='-1'
	fi
	(( count++ ))
done

echo ${INDEXES[*]}

exit 0;
