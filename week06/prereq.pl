#!/usr/bin/perl
#Perl script which prints courses which can be used to meet prerequisite requirements for a UNSW course

#@prereqs=();

#for $prereq (sort(@prereqs)) {
#	print "$prereq\n" if ($prereq ne $last); 	#there are duplicates in the array, hack so they aren't printed
#	$last = $prereq;
#}

#sub get_prereq{
	$ugrad_url = "http://www.handbook.unsw.edu.au/undergraduate/courses/2015/$ARGV[0].html";
	$pgrad_url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2015/$ARGV[0].html";

	open F, "wget -q -O- $ugrad_url $pgrad_url|" or die;

	while ($line = <F>) {
		if($line =~ /.*Prerequisite:.*|.*Prerequisites:.*/){
			$line =~ s/Excluded:.*//g;
			@matches = $line =~ /[A-Z]{4}[0-9]{4}/gi;
			for $match (@matches){
			#if (!is_seen($match)){
#				push(@prereqs, $match);
				print "$match\n";
#				&get_prereqs($match) if $recursive;
			#}
			
			}
				
		}

	}
#}
#sub is_seen {
#	my $found;
#	for $val (@prereqs) {
#		if ($val eq $_[0]) {
#			$found = 1;
#		}
#	}
#	return $found;
#}
