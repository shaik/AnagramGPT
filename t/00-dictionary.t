#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);  # Ensure STDOUT/STDERR use UTF-8
use Test::More tests => 2;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Anagram::Dictionary;

# Create a temporary dictionary file for testing
my $test_dict_file = "$FindBin::Bin/test_hebrew_dict.txt";
open my $fh, '>:encoding(UTF-8)', $test_dict_file or die "Cannot create $test_dict_file: $!";
print $fh "של\nאת\n";  # Two test words
close $fh;

# Create a dictionary object using our test file.
my $dict = Anagram::Dictionary->new(dict_file => $test_dict_file);

# get_words returns an array reference, so we use it directly.
my $words = $dict->get_words;

# Test that the dictionary loaded the words correctly.
is_deeply($words, ["של", "את"], "Dictionary loads words correctly");

# Test the normalization function.
is( Anagram::Dictionary::normalize_word("ךםןףץ"), "כמנפצ",
    "Normalization maps final letters to their base forms correctly" );

# Cleanup: remove the temporary dictionary file.
unlink $test_dict_file or warn "Could not remove $test_dict_file: $!";
