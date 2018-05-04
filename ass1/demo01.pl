#!/usr/bin/perl -w
# put your demo script here
print "Enter number x: ";
$x = <STDIN>;
chomp $x;
print "Enter number y: ";
$y = <STDIN>;
chomp $y;
if($x == $y){
	print "by golly you've done it!\n";
} else {
	print "hint: what if they were the same?\n";
	exit;
}
my $num_lines = 1;
print "Enter a few lines now for your chance to win! Win what? I don't know!\n";
print "You say:\n";
while ($line = <STDIN>){
	if ($line =~ /Cat|Dog|dog|cat/) {
		print "I say: I love animals!!\n";
		last;
	} else {
		print "I say: I guess that's an OKAY choice of input I really like fluffy things...\n";
	}
	$num_lines++;
}

print "that only took you $num_lines tries to get\n";
