#!/usr/local/bin/python3.5 -u
import fileinput, re
# written by andrewt@cse.unsw.edu.au as a 2041 lecture example
# count how many people enrolled in each course

open F, "<course_codes"
for line in <F>:
    if line =~ /(\S+)\s+(.*\S)/:
    course_names{1= 2
close F

for line in fileinput.input():
line = line.rstrip()
course = line
course = re.sub(r'\|.*', '', course)
count{course += 1

for course in sort keys %count:
print("students enrolled" % (course_names{coursehas, count{course}))
