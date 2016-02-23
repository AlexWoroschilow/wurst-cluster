#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

my $dirname = dirname(__FILE__);
require("$dirname/bootstrap.pl");

sub main ($ $ $ $) {
	my ( $cluster_aacid, $cluster_salami, $graph_aacid, $graph_salami ) =
	  ( $_[0], $_[1], $_[2], $_[3] );

	my @structures = create_structure_list($graph_aacid);
	my $structures_count = scalar(@structures);
	(print("Count: structures: $structures_count\n"));

	my %hashtable_cluster_aacid  = create_hashtable_cluster($cluster_aacid);
	my $hashtable_cluster_aacid_count = scalar(keys %hashtable_cluster_aacid);
	(print("Count: $cluster_aacid: $hashtable_cluster_aacid_count\n"));

	my %hashtable_cluster_salami = create_hashtable_cluster($cluster_salami);
	my $hashtable_cluster_salami_count = scalar(keys %hashtable_cluster_salami);
	(print("Count: $cluster_salami: $hashtable_cluster_salami_count\n"));

	my %hashtable_graph_aacid  = create_hashtable_graph($graph_aacid);
	my $hashtable_graph_aacid_count = scalar(keys %hashtable_graph_aacid);
	(print("Count: sequence graph |V|: $hashtable_graph_aacid_count\n"));
	
	my %hashtable_graph_salami = create_hashtable_graph($graph_salami);
	my $hashtable_graph_salami_count = scalar(keys %hashtable_graph_salami);
	(print("Count: structure graph |V|: $hashtable_graph_salami_count\n"));

	print("csv;in both clusters;structure a;structure b;tm_score aacid;tm_score salami\n");


	for my $structure1 (@structures) {

		next if( not exists $hashtable_cluster_aacid{"$structure1"} 
			or not exists $hashtable_cluster_salami{"$structure1"});

		for my $structure2 (@structures) {

			next if ( not exists $hashtable_cluster_aacid{$structure2} 
				or not exists $hashtable_cluster_salami{$structure2});

			my $structure1_cluster_salami = $hashtable_cluster_salami{$structure1};
			my $structure2_cluster_salami = $hashtable_cluster_salami{$structure2};

			next if ( $structure1_cluster_salami != $structure2_cluster_salami );

			my $structure1_cluster_aacid = $hashtable_cluster_aacid{$structure1};
			my $structure2_cluster_aacid = $hashtable_cluster_aacid{$structure2};
				
			my $hash1 = "$structure2$structure1";

			next if (not $hashtable_graph_aacid{$hash1} 
				or not $hashtable_graph_salami{$hash1});

			my $similarity_aacid  = $hashtable_graph_aacid{$hash1};
			my $similarity_salami = $hashtable_graph_salami{$hash1};
			my $in_both_clusters = ($structure1_cluster_aacid == $structure2_cluster_aacid) ? 1 : 0;

			print("csv;$in_both_clusters;$structure1;$structure2;$similarity_aacid;$similarity_salami\n");
		}
	}
	return 1;
}

$ARGV[0] = "out/aacid.clust";
$ARGV[1] = "out/salami.clust";
$ARGV[2] = "var/aacid.ncol";
$ARGV[3] = "var/salami.ncol";

massert( defined( $ARGV[0] ), "Cluster aacid file can not be empty" );
massert( defined( $ARGV[1] ), "Cluster salami file can not be empty" );
massert( defined( $ARGV[2] ), "Graph aacid file can not be empty" );
massert( defined( $ARGV[3] ), "Graph salami file can not be empty" );

exit( main( $ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3] ) );
