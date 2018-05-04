#!/usr/bin/python2.7

pods = dict()
individuals = dict()

import sys
import re

for line in sys.stdin:
	lineinput = line.split(" ")
	animal = lineinput[1].split("\n")
	if animal[0] in individuals:
		individuals[animal[0]] += lineinput[0]
		pods[animal[0]] += 1
	else:
		individuals[animal[0]] = lineinput[0]
		pods[animal[0]] = 1
space = " "
stuff = sys.argv
stuff.remove(sys.argv[0])
input_animal = space.join(stuff)
#print (sys.argv, "observations: ", pods[sys.argv], "pods")
if space in individuals:
	print stuff, "observations: ", pods[stuff], "pods,", individuals[stuff], "individuals"
else:

	print stuff, "observations: 0 pods, 0 individuals"
