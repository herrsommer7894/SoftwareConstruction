#!/usr/bin/perl -w
# put your demo script here
#source: /home/cs2041//public_html/16s2/code/perl/gender_reversal.4.pl
print "enter Hermonie or Harry... or Zaphod if you're feeling adventerous ;)\n";
while ($line = <>) {
    chomp $line;
    $line =~ s/Herm[io]+ne/Zaphod/;
    $line =~ s/Harry/Hermione/;
    $line =~ s/Zaphod/Harry/;
    print $line;
}

