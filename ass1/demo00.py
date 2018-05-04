#!/usr/local/bin/python3.5 -u
import sys, re

o_count = 0
print ("I wonder how many words have vowels are in the sentence:")

print ("hint: try for 10 words with vowels! Ctrl+D to sys.exit")

for line in sys.stdin:
    if re.match(r'[AEIOUaeiou]', line):
        o_count += 1

print("There were %d words with vowels" % o_count)

if o_count == 10:
    print ("HAHA YOU GAVE IN")

