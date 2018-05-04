#!/usr/bin/perl

%log_prob = ();

foreach my $file(glob "poems/*.txt"){
	open (F, "<", $file) or die;
	$file =~ s/poems\/|\.txt//g;
	$file =~ s/_/ /g;
	$num_words = 0;
	#my $find_count = 0;
	my %word_hash = ();

	while (my $line = <F>){
		$line = lc $line;
		chomp($line);
		my @words = $line =~ /[a-z]+/g;
		foreach my $word (@words){
			#if ($word eq $lc_findMe){			
			#	$find_count+=1;
			if(exists $word_hash{$word}){
				$word_hash{$word} += 1
			} else {
				$word_hash{$word} = 1
			}	
			$num_words++;
		}
	
	}
	$log_prob{$file}{"num_words"} = $num_words;
	#print "$file $log_prob{$file}{'num_words'}\n";
	foreach $key (keys %word_hash){
		$word_logfreq = log(($word_hash{$key}+1)/$log_prob{$file}{"num_words"});
		$log_prob{$file}{$key} = $word_logfreq;
		
	}
	#close(F);
	#$poet{$file}{"count"} = $find_count;
	#$frequency = log(($poet{$file}{"count"}+1)/$num_words);
	#$poet{$file}{"freq"} = $frequency; 
	#$poet{$file}{"num_words"} = $num_words;
	#print "$file - $poet{$file}{'count'} $poet{$file}{'freq'} $poet{$file}{'num_words'}\n";
	#printf("log((%d+1)/%6d) = %8.4f %s\n", $poet{$file}{'count'}, $poet{$file}{'num_words'}, $poet{$file}{'freq'}, $file);
}
	#foreach $key (keys %poet){
	#	$who = 
		#foreach $key (keys %poet{$poet_key}){
		#printf("log((%d+1)/%6d) = %8.4f %s\n", $poet{$poet_key}{'count'}, $poet{$poet_key}{'num_words'}, $poet{$poet_key}{'freq'}, $key);
		#}
		
	#}

		

foreach my $file (@ARGV){
	
	my %final = ();
	foreach my $poet (keys %log_prob){
		#~xprint "currently looking at $poet with file of $log_prob{$poet}{'num_words'} words\n";
		$total_log_prob = 0;
		open(my $fh, "<",$file) or die;
		while (my $line = <$fh>){
			$line = lc $line;
			chomp($line);
			my @words = $line =~ /[a-z]+/g;
			foreach my $word (@words){
				if(exists $log_prob{$poet}{$word}){
					#print"$total_log_prob += $log_prob{$poet}{$word} =>";
					$total_log_prob += $log_prob{$poet}{$word};
					#print "$total_log_prob\n";
				} else {
					$total_log_prob += log(1/$log_prob{$poet}{"num_words"});
				}
			}
		}
		#printf ("%s: log_probability of %4.1f for %s\n", $file, $total_log_prob, $poet);
		if(exists $final{"poet"}){
			if(($final{"log_prob"}<=>$total_log_prob) == -1){
				$final{"poet"} = $poet;
				$final{"log_prob"} = $total_log_prob;
			}
		} else {
			$final{"poet"} = $poet;
			$final{"log_prob"} = $total_log_prob;
		}
	
	}
	printf ("%s most resembles the work of %s (log-probability=%4.1f)\n", $file, $final{'poet'}, $final{'log_prob'});
	
}
