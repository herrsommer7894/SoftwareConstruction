#!/usr/bin/perl -w

#DONEread from files supplied as command line arguments
#DONEread from standard input if no file name arguments are supplied
#DONEdisplay the error message tail.pl: can't open FileName for any unreadable file
#display the last N lines of each file (default N = 10)
#DONEcan adjust the number of lines displayed via an optional first argument -N
#DONEif there are more than one named files, separate each by ==> FileName <==
$n=10;
@files = ();
foreach $arg (@ARGV){
	if ($arg eq "--version"){
		print "$0: version 0.1\n";
		exit(0);
	} elsif ($arg =~ /-[0-9]+/) {
		$n = $arg;
		$n =~ s/-//;
	} else {
		push @files, $arg;
	}
}

if (scalar @files == 0){
	$i=0;
	foreach $line (<>){
		if($i == 0){
		
		} else {
		 print "$line";
		}
		$i++;
	}
}

foreach $f (@files){
	open(F, "<$f") or die "$0: Can't open $f: $!\n";
	if (scalar @files > 1){
		print "==> $f <==\n"
	}
	$wc_l = `wc -l < $f`;# 2>/dev/null`;
	chomp ($wc_l);
	$i = 0;
	foreach $line (<F>){
		if($i >= ($wc_l - $n)){
			print $line;
		}
		$i++;
	}
	close(F);
}
