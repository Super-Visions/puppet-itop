#!/usr/bin/env perl

use Data::Dumper;
use LWP::Simple;

my $url = 'http://localhost:8001/zip';

my $content = get $url;
die "Couldn't get $url" unless defined $content;

# Then go do things with $content, like this:

my @matches = ( $content =~ m/<a href="(.+)\.zip"/g );

#my @matches = [];
#push @matches, [$1, $2] while $content =~ m/<a href="(.+)-([\d-_\.]+)\.zip"/g;

print Dumper \@matches;

