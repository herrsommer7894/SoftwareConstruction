#!/usr/bin/perl -w

$i = 0;

while ($arg= <STDIN>) {
	$arg[$i] = $arg;
	$i++;
}

$j = 0;
while ($j < $i) {
	$num = rand($i);
	if ($arg[$num] !~ /NaN/) {
		print $arg[$num];
		$arg[$num] = "NaN";
		$j++;
	}
}
