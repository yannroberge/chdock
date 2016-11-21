#!/usr/bin/perl
use strict;
use warnings;

my @OUT = @ARGV;
my $count = 0;

foreach (@ARGV) {

	# Print the first path without a carriage return
	if ($count == 0) {
		print $OUT[$count];
	}
	# Print all following paths with a carriage return
	elsif ($OUT[$count] =~ /file:\/\//) {
		print "\n" . $OUT[$count];
	}
	# If paths are broken into pieces because of spaces in names, print an escaped space then the piece 
	else {
		print "\ " . $OUT[$count];
	}
	$count += 1;
}
print "\n";