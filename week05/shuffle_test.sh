#!/bin/bash
n=$1
i=0
num=0
array=();
while test $i -lt $n
do 
	echo $i; i=$((i + 1))
done | ./shuffle.pl > temp.txt

#populate array with numbers 1-n
while test $num -lt $n
do
	array[$num]="$num"
	((num++))
done


while read line
do
	for elem in "${array[@]}"
	do
		if test "${array[$elem]}" == "$line"
		then
			unset array[$elem]		
		fi

	done
done < temp.txt

if test ${#array[@]} -eq 0
then
	echo "Worked like a dream!"
else
	echo "AW HELL NO"
fi

rm temp.txt

