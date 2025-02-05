#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);  # STDIN, STDOUT, STDERR will use UTF-8
use Getopt::Long;
use Encode;              # For decoding @ARGV
use FindBin;
use lib "$FindBin::Bin/../lib";
use Anagram::Solver;

# Explicitly decode command-line arguments from UTF-8.
@ARGV = map { Encode::decode("UTF-8", $_) } @ARGV;

my $debug = 0;
GetOptions('debug|d' => \$debug);

my $input = shift @ARGV or die "Usage: $0 [-d|--debug] <letters>\n";

my $solver = Anagram::Solver->new(debug => $debug);
my $results = $solver->find_anagrams($input);

if (@$results) {
    foreach my $combo (@$results) {
        print join(" ", @$combo), "\n";
    }
} else {
    print "No anagrams found for '$input'\n";
}
