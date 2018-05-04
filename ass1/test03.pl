#!/usr/bin/perl -w
# put your test script here

while(my $line = <STDIN>)
{
	if($line =~ /YIPEE/) #omg no
	{
		print "Sweet home alabama!\n";
	}

	$life = 0;
	if($line =~ /YIPEE/){ #omg help
		$life ++;
	}

	print "$life lives", "\n";

}
