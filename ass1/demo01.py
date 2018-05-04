#!/usr/local/bin/python3.5 -u
import sys, re
# put your demo script here
print ("Enter number x: ")

x = sys.stdin.readline()
x = x.rstrip()
print ("Enter number y: ")

y = sys.stdin.readline()
y = y.rstrip()
if x == y:
    print ("by golly you've done it!")

else:
    print ("hint: what if they were the same?")

    sys.exit
num_lines = 0
print ("Enter a few lines now for your chance to win! Win what? I don't know!")

print ("You say:")

for line in sys.stdin:
    if re.match(r'Cat|Dog|dog|cat', line):
        print ("I say: I love animals!!")

        break
    else:
        print ("I say: I guess that's an OKAY choice of input I really like fluffy things...")

    num_lines += 1

print("that only took you %d tries to get" % num_lines)
