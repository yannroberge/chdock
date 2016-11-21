#!/usr/bin/perl
use strict;
use warnings;

my @OUT = @ARGV;
my $count = 0;
foreach (@ARGV) {
	$OUT[$count] =~ s/%20/\\\ /g;
	#$OUT[$count] =~ s/file:\/\///g;
	print $OUT[$count] . "\n";
	$count += 1;
}
