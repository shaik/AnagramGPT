#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Test::More tests => 3;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Anagram::Dictionary;
use Anagram::Solver;

# Create a temporary dictionary file for solver testing
my $test_solver_dict = "$FindBin::Bin/test_solver_dict.txt";
open my $fh, '>:encoding(UTF-8)', $test_solver_dict or die "Cannot create $test_solver_dict: $!";
# Use a small dictionary: "של" and "את"
print $fh "של\nאת\n";
close $fh;

# Create a Dictionary object using the test dictionary file.
my $mock_dict = Anagram::Dictionary->new(dict_file => $test_solver_dict);

# Create a Solver object that uses the mock dictionary.
# Setting max_words to 2 (since we expect two-word solutions) and debug to 0.
my $solver = Anagram::Solver->new(
    dict              => $mock_dict,
    max_words         => 2,
    ignore_one_letter => 1,
    debug             => 0,
);

# Test a valid input that should decompose into "את" and "של"
# For example, the letters of "אתשל" (which are "א", "ת", "ש", "ל")
my $input = "אתשל";
my $results = $solver->find_anagrams($input);

ok( scalar(@$results) > 0, "Solver found at least one combination for input '$input'" );

# We expect the combination ["את", "של"] (order may vary, so compare sorted lists)
my $expected = ["את", "של"];
my $found = 0;
foreach my $combo (@$results) {
    # Sort both arrays for comparison.
    my @sorted_combo    = sort @$combo;
    my @sorted_expected = sort @$expected;
    if ( join("", @sorted_combo) eq join("", @sorted_expected) ) {
        $found = 1;
        last;
    }
}
ok( $found, "Solver returned expected combination: [". join(" ", @$expected) ."]" );

# Test an input that cannot be decomposed using our test dictionary.
$input = "אבג";
$results = $solver->find_anagrams($input);
ok( scalar(@$results) == 0, "Solver found no combination for input '$input'" );

# Cleanup: remove the temporary dictionary file.
unlink $test_solver_dict or warn "Could not remove $test_solver_dict: $!";
