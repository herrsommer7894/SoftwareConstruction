#!/usr/bin/perl -w

# written by andrewt@cse.unsw.edu.au September 2016
# as a starting point for COMP2041/9041 assignment 
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/plpy/
# Completed by Yaminn Aung, z5061216

#perl to python translator
#plpy.py


my @codeArray = ();
my %variables = ();
my $line;
my $tab_flag = 0;

while ($line = <>) {
	$line =~ s/;$//g;
	if ($line =~ /^#!/ && $. == 1) {
    		$line =~ s/\/usr\/bin\/perl .*/\/usr\/local\/bin\/python3.5 -u/g;
		push @codeArray, $line;
		next;
        	# translate #! line 
    	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
        	#Blank & comment lines can be passed unchanged
		push @codeArray, $line;
		next;
		
	} else {
		$line =~ s/^\s*//g;
	}
	
	if($line =~ /}/){
		$tab_flag--;
		if($line =~ /}\s*.+/){
			$line =~ s/}\s*//;
		} else {
			$line =~ s/\s*}\n//g;
			next;
		}
	} elsif ($line =~ /^\s*{\n/){
			$line =~ s/{\s*//;
			next;
	}

	my $i;
	if ($tab_flag > 0){
		for $i (1 .. $tab_flag){		
			$line =~ s/^/    /g;
		}
	}


	
	if ($line =~ /\$\w+|\@\w+/){
		&store_var();
	}

	if ($line =~ /print/){
		&py_print();
	} elsif ($line =~ /(else|elsif|if|while|for|foreach)\s*(.)/){
		&control_flow();
	}
	
	
	if ($line =~ /ARGV|STDIN/){
		&sys();
	}
	if($line =~ /<>/){
		&fileinput();
	}
	if ($line =~ /chomp\s*\(*\$\w+\)*|join\(.+\)|split\s*\(*/){
		&change();
		
	}
	if ($line =~ /s\/.*\/.*\/.*|=~\s*\/.+\//){
		&re();
	}
	if ($line =~ /reverse/){
		&py_reverse();
	}
	&variable_plpy_syntax();
	push @codeArray, $line;
    
}

sub store_var {
	my @var = $line =~ /\s*\$(\w+)\s*/g;
	my @array = $line =~ /\s*\@(\w+)\s*/g;
	my @matches = (@var, @array);
	foreach my $found (@matches){
		#print "searching if $found exists in $line";
		if ($found =~ /ARGV/ || exists $variables{$found}){
			#well done you already added this var
			#print $found;
		} else {
			if ($line =~ /\s*\$$found\s*=\s*["'](.*)["']/){
				$variables{$found} = "string";
				#print "Found a string $found\n";
			} elsif($line=~/\s*\$$found\s*=\s*[0-9]+/){#\s*[^x]*/) {
				$variables{$found} = "number";
				#print "Found a number $found\n";
			} elsif($line =~ /\@$found/){
				$variables{$found} = "array";
				#print "Found an array $found\n";
			} elsif ($line =~ /\$$found\s*\(.+\.\..+\)/){
				$variables{$found} = "number";
			} else {
				$variables{$found} = "mix";
				#print "Found a mixed variable $found in line $line";
			}
		}
	}
}

sub py_reverse{
	my $var;
	if ($line =~ /reverse\s*\(*\s*\@(\w+)\)*/){
		$var = $1;
		$line =~ s/reverse\s*\(*\s*\@\w+\)*/$var.reverse/g;
	} elsif ($line =~ /scalar\s+reverse\s+(.+)\)*/){
		if($line =~ /reverse\s+\$\w\s*|reverse\s+["'].+[^, "|^, ']["']/){
			$line =~ /scalar\s+reverse\s+(.+)\)*/;
			$line =~ s/scalar\s+reverse\s+(.+)\)*/''.join(reversed($1))/;
		}
	} #need to include reverse a hash


}
sub change {
	my $var;
	my $var1;
	my $var2;
	my @words;
	if ($line =~ /chomp/){
		$line =~ /chomp\s*\(*(\$\w+)\)*/;
		$var = $1;
		$line =~ s/chomp\s*\(*\$\w+\)*/$var = $var.rstrip\(\)/g;
	}
	if ($line =~ /join/){
		$line =~ /join\((.+)\)/;
		$var = $1;
		@words = split(/, /, $var, 2);
		$var1 = $words[0];
		$var2 = $words[1];
		$line =~ s/join\(.*\)/$var1\.join\($var2\)/g;
	}
	if ($line =~ /split/){
		print "yo\n";
		if($line =~ /split\s*\(*\/(.*)\/,\s*(.+),\s*(\w+)\)*/){
			$var = $1;
			$val1 = $2;
			$val2 = $3;
			$val2 =~ s/\)$//;
			$line =~ s/split\s*\(*\/.*\/,\s*.+,\s*\w+\)*/$val1.split($var, $val2)/;
		} elsif($line =~ /split\s*\(*\/(.*)\/,\s*(.+)\s*\)*/){
			$var = $1;
			$val1 = $2;
			$val1 =~ s/\)$//;
			print "$line $var\n$val1\n";
			$line =~ s/split\s*\(*\/(.*)\/,\s*(.+)\s*\)*/$val1.split($var)/;
		}
	}
	
}
sub fileinput {
	my $var;
	my $found = 0;
	for my $check (@codeArray){
		if ($check =~ /import/){
			if($check !~ /fileinput/){
				$check =~ s/$/, fileinput/;
			}
			$found = 1;
			last;
		}
	}
	if ($found == 0) {
		$first_line = shift(@codeArray);
		unshift @codeArray, "import fileinput\n";
		unshift @codeArray, $first_line;
	} 
	if($line =~ /\<\>/){
		$line =~ s/\<\>/fileinput.input\(\)/;
	}
}
sub re {
	my $var;
	my $val1;
	my $val2;
	my $first_line;
	my $found = 0;
	for my $check (@codeArray){
		if ($check =~ /import/){
			if($check !~ /re/){
				$check =~ s/$/, re/;
			}
			$found = 1;
			last;
		}
	}
	if ($found == 0) {
		$first_line = shift(@codeArray);
		unshift @codeArray, "import re\n";
		unshift @codeArray, $first_line;
	} 

	#translates s///
	if($line =~ /\$(.+)\s*\=\~\s*s\/(.*)\/(.*)\/.*/){
		$var = $1;
		$val1 = $2;
		$val2 = $3;
		$var =~ s/ $//g;
		$line =~ s/\=\~\s*s\/.*\/.*\/.*/= re.sub(r'$val1', '$val2', $var)/;
	}
	
	#translates //
	if($line =~ /\$(\w+)\s*=~\s*\/(.+)\//){
		$var = $1;
		$val1 = $2;
		$line =~ s/$var\s*=~\s*m*\/.+\//re.match(r'$val1', $var)/;	
	}

}

sub sys {
	my $first_line;
	my $var;
	my $found = 0;
	for my $check (@codeArray){
		if ($check =~ /import/){
			if($check !~ /sys/){
				$check =~ s/$/, sys/;
			}
			$found = 1;
			last;
		}
	}
	if ($found == 0) {
		$first_line = shift(@codeArray);
		unshift @codeArray, "import sys\n";
		unshift @codeArray, $first_line;
	} 

	if($line =~ /<STDIN>/){
		if($line =~ /for|while|print|if|elif/){
			$line =~ s/<STDIN>/sys.stdin/g;
		} else {
			$line =~ s/<STDIN>/sys.stdin.readline()/g;
		}
	} elsif ($line =~ /\@ARGV/){
		if($line =~ /for|while|print|if|elif|/){
			$line =~ s/\@ARGV/sys.argv[1:]/g;
		} else {
			$line =~ s/\@ARGV/sys.argv/g;
		}
	} elsif ($line =~ /\$ARGV/){
		if ($line =~ /\$*ARGV\[\$(.+)\]|\$ARGV\[([0-9]+)\]/){
			$var = $1;
			$line =~ s/\$*ARGV\[.+\]/sys.argv[$var + 1]/;
		}
	} elsif ($line =~ /\$#ARGV/){
		$line =~ s/\$#ARGV/len(sys.argv) - 1/;
	}
}

sub py_print {
	# Python's print adds a new-line character by default
        # so we need to delete it from the Perl print statement
	print "here for $line";
	$line =~ /print\s*"*\(*(.*),*\s*\)*"*\\*n*"/;
	$var = $1;
	$var =~ s/\\n$//;
	print "$var\n";
	if ($var =~ /\$.+|\@.+/){
		$var =~ s/[\s,] "$//g;
		$check = $var;
	
		$check =~ s/^\$//;

		if (exists $variables{$check}){
       			$line =~s/print\s*"(.*)\\n"[\s;]*/print($var)\n/;
		} elsif ($var =~ /join\s*\(|eval\s*\(|split\s*\(|ARGV/){
			$line =~ s/print.*["']\n/print\($var\)\n/g;
		} elsif ($line =~ /\+|\-|\*{1,2}|\/|\%/){
			$line =~s/print\s*.+/print($var)\n/;
		} else {
			$temp_line = "print(\"";
			@words = split(/\s/,$var);
			@vars = ();
			foreach $variable (@words){
				if($variable =~ /^\$(\w+)/){
					if($variables{$1} eq "string"){
						$temp_line .= "%s ";
					} elsif ($variables{$1} eq "number"){
						$temp_line .= "%d ";
					} else {
						$temp_line .= "%s ";
					}
					push @vars, $variable;
				} else {
					$temp_line .= "$variable ";
				}
			}
			$temp_line =~ s/\s$/" % (/;
			foreach $found (@vars){
				if(scalar(@vars) == 1){
					$temp_line =~ s/% \(/% /;
					$temp_line .= "$found ";
					$temp_line =~ s/\s$/)\n/;
					last;
				} else {
					$temp_line .= "$found, ";
				}
			}
			if (scalar(@vars) > 0){
				$temp_line =~ s/,\s$/))\n/;
			}
			$line =~ s/print.*["']\n/$temp_line/g;
					
		}
	} else {
		#$line =~s/print\s*"(.*)\\n"[\s;]*$/print("$var")\n/;
		$line =~ s/print.+/print ("$var")\n/;
	}
	return $line;

}

sub control_flow{
	my $val1 = 0;
	my $val2 = 0;
	my $var = 0;
	my $i = 0;

	if ($line =~ /(else|elsif|if|while|for|foreach)\s*(.)/){
			$line =~ s/\s*{//g;
			$line =~ s/\s*my//;
			$tab_flag++;
			if($line =~ /elsif|else/){
				if($line =~ /elsif\s*\((.+)\)/){
					$line =~ s/elsif\s*\((.+)\)/elif $1:/g;
				} else {
					$line =~ s/else/else:/g;
				}
			} elsif($line =~ /while/){
				$line =~ /while\s*\((.*)\)/;
				$var = $1;
				if($var =~ /<.*>/){
					$line =~ /while\s*\(\s*(\$.+)\s*=\s*(.+)\)/;
					$val1 = $2;
					$var = $1;
					$var =~ s/\s//;
					$line =~ s/while\s*\(.+\)/for $var in $val1:/;
				} else {
					$line =~ s/\(.*\)/$var:/g;
				}

			} elsif($line =~ /for\s*\(.+;.+;.+\)/){
				#if ($line =~ /for\s*\(.+;.+;.+\)/){
					$line =~ /\(\s*(.+)\s*=\s*(.*)\s*;\s*.+\s*.*\s*(.+)\s*;\s*.+\)/;
					$val1 = $2;
					$val2 = $3;
					$var = $1;
					$var =~ s/\s//g;
					if($val1 == 0){
						$line =~ s/for\s*\(.+\)/for $var in range($val2):/g;
					} else {
						$line =~ s/for\s*\(.+\)/for $var in range($val1, $val2):/g;
					}
			} elsif($line =~ /for\s+\$\w+\s*\(/){
				if($line =~ /for\s+(.+)\s*\(\s*(.+)\s+\.\.\s+(.+)\)/) {
					$line =~ /for\s+(\$\w)+\s*\(\s*(.+)\s+\.\.\s+(.+)\)/;
					$var = $1;
					$var =~ s/\s+//g;
					$val1 = $2;
					$val2 = $3;
					if($val1 == 0){
						$line =~ s/for\s+\$\w+\s*\(\s*.*\s+\.\.\s+.*\)/for $var in range($val2):/g;
					} else {
						$line =~ s/for\s+.+\s\(\s*.*\s+\.\.\s+.*\)/for $var in range($val1, $val2):/g;
					}
				} else {
					#print "here\n";
					$line =~ /for (\$\w+)\s*\((.+)\)/;
					$var = $1;
					$val1 = $2;
					$line =~ s/for\s+\$\w+\s*\(.+\)/for $var in ($val1):/; 
				}
			} elsif ($line =~ /foreach/){
				$line =~ /foreach\s(.+)\s\((.+)\)/;
				$var = $1;
				$val1 = $2;
				if($val1 =~ /(.+)\s*\.\.\s*(.+)/){
					$val2 = $2;
					$val1 = $1;
					if ($val2 =~ /ARGV/){
						if($val1 == 0){
							$line =~ s/foreach\s.+\s\(.+\)/for $var in range($val2):/g;
						} else {
							$line =~ s/foreach\s.+\s\(.+\)/for $var in range($val1, $val2):/g;
						}
					} else {
						if($val1 == 0){
							$line =~ s/foreach\s.+\s\(.+\)/for $var in range($val2+1):/g;
						} else {
							$line =~ s/foreach\s.+\s\(.+\)/for $var in range($val1, $val2+1):/g;	
						}
					}				
				} else {
					$line=~ s/foreach\s.*\s\(.+\)/for $var in $val1:/g;
				}
				
			} elsif ($line =~ /if\s*\((.+)\)/){
				$var = $1;
				$line =~ s/if\s*\(.+\)/if $var:/g;
			} 
	}
	#print "$line\n";
	return $line;

}

sub variable_plpy_syntax{
	my @matches;
	my $var;
	
	$line =~ s/\.=/+=/g;
	$line =~ s/\blast\b/break/;
	$line =~ s/\bnext\b/continue/;


	#fix operators
	$line =~ s/eq/==/;
	#$line =~ s/.=/+=/g;
	if ($line =~ /\|\||&&/){
		$line =~ s/\|\|/or/g;
		$line =~ s/&&/and/g;
		#$line =~ s/!/not/g;	
	}
	

	if($line =~ /\$(\w+)\s*\+\+|\$(\w+)\s*\-\-/){
		if($line =~ /\+\+/){
			$line =~ /\$(\w+)\s*\+\+/;
			$var = $1;
			$line =~ s/\$\w+\s*\+\+/$var += 1/;
		} else {
			$line =~ /\$(\w+)\s*\-\-/;
			$var = $1;
			$line =~ s/\$(\w+)\s*\-\-/$var -= 1/;
		}
	}
	#remove $/my $ from variable
	if ($line =~ /\$(\w+)/){
		@matches = $line =~ /\s*\$(\w+)*\s*/gi;
		foreach $found (@matches){
			$found =~ s/\$//g;
			#print "$found\n";
			if($line =~ /my\s*\$$found/){
				#print "$line=>";
				$line =~ s/my\s*\$$found/$found/g;
				#print "$line";
			} else {
				#print "wowza\n";
				$line =~ s/\$$found/$found/g;
			}
			#change $#array to len(array)-1
			if($line =~ /\#$found/){
				$line =~ s/\#$found/len($found)-1/;
			}
			#print "$line";
		}
	}

	if($line =~ /\@(\w+)/){
		$var = $1;
		#fix aray initialisation
		if($line =~ /\@$var\s*=\s*\((.*)\)/){
			$var = $1;
			$line =~ s/=\s*\(.+\)/= \[$var\]/;	
		} 
		#fix scalar(@array) to len(@array)
		if($line =~ /scalar\(\s*\@(\w+)\s*\)/){
			$var = $1;
			$line =~ s/scalar\(\s*\@$found\s*\)/len($found)/;
		}

		#fix push @array, somevalue
		if ($line =~ /push\s*\(*\s*\@(\w+),\s*(.+)\)*/){
			$var = $1;
			$val1 = $2;
			$val1 =~ s/\)$//;
			if($val1 !~ /\@\w+/){
				#print "$val1\n";
				$line =~ s/push\s*\(*\s*\@\w+,\s*.+\)*/$var\.append($val1)/;
			} else {
				#print "here\n";
				#print "$val1\n";
				$line =~ s/push\s*\(*\s*\@\w+,\s*\@\w+\)*/$var\.extend($val1)/;
			}
		} elsif ($line =~ /pop\s*\(*\s*\@(\w+)\)*/){
			$var = $1;
			$line =~ s/pop\s*\(*\s*\@\w+\)*/$var.pop()/;
		} elsif ($line =~ /unshift\s*\(*\@(\w+)\s*,\s*(.+)\s*\)*/){
			$var = $1;
			$val1 = $2;
			$line =~ s/unshift\s*\(*\@\w+\s*,\s*.+\s*\)*/$var.insert(0,$val1)/;
		} elsif($line =~ /\s*shift\s*\(*\s*\@(\w+)\)*/){
			$var = $1;
			$line =~ s/shift\s*\(*\s*\@\w+\)*/$var.pop(0)/;
		}
		#remove @/my @ from array
		@matches = $line =~ /\s*\@(\w+)*\s*/gi;
		foreach $found (@matches){
			$found =~ s/\@//g;
			if($line =~ /my\s*\$$found/){
				$line =~ s/my\s*\@$found/$found/g;
			} else {
				$line =~ s/\@$found/$found/g;
			}
		}
		
	}
	return $line;
}


foreach $elem (@codeArray){
	print"$elem";
}
