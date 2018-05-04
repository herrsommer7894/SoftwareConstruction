#!/usr/bin/perl

if ( @ARGV != 2){
	print "Usage: ./echon.pl <number of lines><string> at ./echon.pl line 3";
	exit;
} else {
	for ($i=0; $i<$ARGV[0]; $i++){
		print "$ARGV[1]" . "\n";
	}
}
