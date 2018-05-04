#!/usr/local/bin/python3.5 -u
import sys
# put your demo script here

days = ['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday']
print ("What's your favourite day of the week?:")

answer = sys.stdin.readline()

for day in days:
    if day == answer:
        print ("Gross, why a weekday?")

        break
num_days = len(days)
print("number of weekdays are %s" % num_days)

i = 0
array = ()
for arg in sys.argv[1:]:
    array[i] = arg
    i += 1
print ("len(sys.argv) - 1")

k = i
while k != 0:
    print("%s" % array[k])
    k -= 1

