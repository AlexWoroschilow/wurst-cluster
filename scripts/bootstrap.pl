#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw(any);

sub massert ($ $) {
	my ( $condition, $message ) = ( $_[0], $_[1] );

	if ( !$condition ) {
		exit( print($message) );
	}
}

sub create_structure_list ($) {
	my ($file) = ( $_[0] );
	open( INPUT, "<$file" ) or die "Could not open '$file' $!\n";

	my %hashtable;

	while ( my $line = <INPUT> ) {
		chomp $line;
		my @fields = split "\t", $line;

		my $structure = $fields[0];
		my $structure_exists = defined($hashtable{$structure});
		next if ($structure_exists);

		$hashtable{$structure} = 1;
	}
	return keys %hashtable;
}

sub create_hashtable_graph ($) {
	my ($file) = ( $_[0] );
	open( INPUT, "<$file" ) or die "Could not open '$file' $!\n";

	my %hashtable;

	while ( my $line = <INPUT> ) {
		chomp $line;
		my @fields = split "\t", $line;

		my $structure1 = $fields[0];
		my $structure2 = $fields[1];
		my $similarity = $fields[2];

		$hashtable{"$structure1$structure2"} = $similarity;
	}

	return %hashtable;
}

sub create_hashtable_cluster ($) {
	my ($file) = ( $_[0] );
	open( INPUT, "<$file" ) or die "Could not open '$file' $!\n";

	my %hashtable;

	while ( my $line = <INPUT> ) {
		chomp $line;
		my @fields = split "\t", $line;

		my $cluster   = $fields[0];
		my $structure = $fields[2];

		$hashtable{$structure} = $cluster;
	}

	return %hashtable;
}

return 1;