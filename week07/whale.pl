#!/usr/bin/perl

@args=();
%individuals=();
%count=();
for $elem (@ARGV){
	while (EOF != ($input = <STDIN>)){
	#print "$input";
		my ($number, $animal) = split / /, $input, 2;
		chomp($animal);
		if (exists $count{$animal}) {
			$count{$animal} += 1;
			$individuals{"$animal"} += $number;
		} else {
			$count{"$animal"} = 1;
			$individuals{"$animal"} = $number;
		}
	}

#print the hash
#foreach $name (keys %hash) {
#$hash{$name} =~ s/,//; # remove comma prefix
#print "$name $hash{$name}\n";
#}
		if (exists $count{$elem}){
			print "$elem observations: $count{$elem} pods, $individuals{$elem} individuals\n";
		} else {
			print "$elem observations: 0 pods, 0 individuals\n";
		}
	


}
