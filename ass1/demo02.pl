#!/usr/bin/perl -w
# put your demo script here
#/home/cs2041//public_html/16s2/code/perl/line_count.1.pl

$line_count = 0;
while(<STDIN>){
	$line_count ++;
}
print "$line_count lines\n";
