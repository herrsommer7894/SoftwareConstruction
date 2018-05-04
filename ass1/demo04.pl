#!/usr/bin/perl -w
# put your demo script here

@days = ('Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday');
print "What's your favourite day of the week?:";
$answer = <STDIN>;

foreach my $day (@days){
if($day eq $answer){
print "Gross, why a weekday?\n";
last;
	}
}
$num_days = scalar(@days);
print "number of weekdays are $num_days\n";

$i = 0;
@array = ();
foreach $arg (@ARGV) {
    $array[$i] = $arg;
    $i++;
}
print "$#ARGV\n";
$k = $i;
while ($k != 0) {
    print "$array[$k]\n";
    $k--;
}

