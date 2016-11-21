#!/bin/bash

# Options available:
# 	-v -> verbose
#	-l -> list
#	-a -> scope in apps
#	-f -> scope in files
#	-e -> execute [position in Dock]
#	-r -> remove [position in Dock]
#	-s -> search (returns position in dock, or "File(s) not found in Dock")

set -v verbose
./lsdock.sh
set +v verbose
