# chdock

chdock is a command-line tool for editing docks under OSX.
Its objective is to allow the use the dock change in shell scripts and programs

How to install/use:

-Copy the repository to an installation folder of your choice.
-Execute chdock.sh:
<code>./chdock.sh -l</code> 
...lists the entire dock's contents
<code>./chdock.sh -la</code>
...lists the apps placed in the dock left of the vertical separation bar
<code>./chdock.sh -lf</code>
...lists the files placed in the dock right of the vertical separation bar

or

-List dock items
<code>./lsdock.sh</code>
...lists the entire dock's contents
<code>./lsdock.sh -a</code>
...lists the apps placed in the dock left of the vertical separation bar
<code>./lsdock.sh -f</code>
...lists the files placed in the dock right of the vertical separation bar

or

-Remove dock items
<code>./rmdock.sh [-a|f] [-i] [-n] path|position...</code>
...removes the file at <code>path</code>, or whichever file is at <code>position</code> in the dock 

A script for adding dock elements is currently being worked on

