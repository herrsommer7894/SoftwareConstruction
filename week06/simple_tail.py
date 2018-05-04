#!/usr/bin/python2.7

import sys

for arg in sys.argv[1:]:
	num_lines = sum(1 for line in open(arg))
	i = 0
	fp = open(arg)
	if (num_lines < 10):
		while(i<=num_lines):
			if(i > 0):
				sys.stdout.write(fp.readline())#.rstrip("\n")
			i = i + 1
			#else:
				#i = i + 1
	else: #numlines is >= 10
		#print num_lines
		n=0
		while (n <= num_lines):
			if (n >= num_lines - 10):
				#print i
				sys.stdout.write(fp.readline())
				i = i + 1
			else:
				fp.readline().rstrip("\n")
			n = n + 1				

