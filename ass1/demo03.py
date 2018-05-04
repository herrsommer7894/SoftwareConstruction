#!/usr/local/bin/python3.5 -u
import fileinput, re
# put your demo script here
#source: /home/cs2041//public_html/16s2/code/perl/gender_reversal.4.pl
print ("enter Hermonie or Harry... or Zaphod if you're feeling adventerous ;)")

for line in fileinput.input():
    line = line.rstrip()
    line = re.sub(r'Herm[io]+ne', 'Zaphod', line)
    line = re.sub(r'Harry', 'Hermione', line)
    line = re.sub(r'Zaphod', 'Harry', line)
    print(line)

