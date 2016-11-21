#!/usr/bin/python
import sys, urllib

#print sys.argv
for i in range(1,len(sys.argv)):
	print urllib.unquote_plus(sys.argv[i])