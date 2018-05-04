#!/usr/bin/python2.7

import sys

if len(sys.argv) != 3:
	print "Usage: ./echon.py <number of lines> <string>"
	raise SystemExit
elif sys.argv[2].isdigit():
	print "Usage: ./echon.py <number of lines> <string>"
	raise SystemExit
elif sys.argv[1].startswith('-'):
	print "./echon.py: argument 1 must be a non-negative integer"
	raise SystemExit
else:
	i = 0
	while (i<int(sys.argv[1])):
		print sys.argv[2]
		i = i + 1

