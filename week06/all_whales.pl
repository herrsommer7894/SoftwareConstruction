#!/usr/bin/perl

@args=();
%individuals=();
%count=();

while (EOF != ($input = <STDIN>)){
	#print "$input";
	my ($number, $animal) = split / /, $input, 2;
	chomp($animal);
	$animal =~ s/^\s+|\s+$|//g;
	$animal =~ s/  +/ /g;
	$species = lc $animal;
	$species =~ s/s$//g;
	if (exists $count{$species}) {
		$count{$species} += 1;
		$individuals{"$species"} += $number;
	} else {
		$count{"$species"} = 1;
		$individuals{"$species"} = $number;
	}
}

foreach $name (sort keys %individuals){
	print "$name observations: $count{$name} pods, $individuals{$name} individuals\n";
}

#print the hash
#foreach $name (keys %hash) {
#$hash{$name} =~ s/,//; # remove comma prefix
#print "$name $hash{$name}\n";
#}
		#if (exists $count{$elem}){
		#	print "$elem observations: $count{$elem} pods, $individuals{$elem} individuals\n";
		#} else {
		#	print "$elem observations: 0 pods, 0 individuals\n";
		#}
	



