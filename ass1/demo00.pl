#!/usr/bin/perl -w

my $o_count = 0;
print "I wonder how many words have vowels are in the sentence:\n";
print "hint: try for 10 words with vowels! Ctrl+D to exit\n";
while ($line = <STDIN>){
	if ($line =~ /[AEIOUaeiou]/){
		$o_count++;
	}
}

print "There were $o_count words with vowels\n";

if($o_count == 10){
	print "HAHA YOU GAVE IN\n";
}
