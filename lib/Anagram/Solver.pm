package Anagram::Solver;
use strict;
use warnings;
use utf8;
use Anagram::Dictionary;

sub new {
    my ($class, %args) = @_;
    my $self = {
        dict              => $args{dict} || Anagram::Dictionary->new(),
        ignore_one_letter => defined $args{ignore_one_letter} ? $args{ignore_one_letter} : 1,
        max_words         => $args{max_words} || 3,
        debug             => $args{debug} // 0,
    };
    bless $self, $class;
    $self->_prepare_dictionary();
    return $self;
}

sub _prepare_dictionary {
    my ($self) = @_;
    my @dict_words;
    for my $word ( @{ $self->{dict}->get_words } ) {
        chomp $word;
        next if $self->{ignore_one_letter} && length($word) == 1;
        my $normalized = Anagram::Dictionary::normalize_word($word);
        my $freq = _compute_frequency($normalized);
        push @dict_words, { word => $word, normalized => $normalized, freq => $freq };
    }
    @dict_words = sort { $a->{normalized} cmp $b->{normalized} } @dict_words;
    $self->{dict_words} = \@dict_words;
}

# Compute a frequency map (hash reference) for the given (normalized) word.
sub _compute_frequency {
    my ($word) = @_;
    my %freq;
    $word =~ s/\s+//g;  # remove any whitespace
    foreach my $char (split //, $word) {
         $freq{$char}++;
    }
    return \%freq;
}

# Check if frequency map $sub is a subset of $super.
sub _is_subset {
    my ($sub, $super) = @_;
    for my $char (keys %$sub) {
         return 0 unless (exists $super->{$char} && $super->{$char} >= $sub->{$char});
    }
    return 1;
}

# Subtract frequency map $sub from $super and return a new frequency map.
sub _subtract_freq {
    my ($super, $sub) = @_;
    my %new = %$super;
    for my $char (keys %$sub) {
         $new{$char} -= $sub->{$char};
         delete $new{$char} if $new{$char} <= 0;
    }
    return \%new;
}

# Helper to convert a frequency map to a string for debugging.
sub _freq_to_string {
    my ($freq) = @_;
    my @pairs;
    foreach my $char (sort keys %$freq) {
         push @pairs, "$char: $freq->{$char}";
    }
    return "{" . join(", ", @pairs) . "}";
}

# The recursive search routine.
sub _search {
    my ($self, $remaining, $start_index, $current, $results) = @_;
    
    if ($self->{debug}) {
        print "DEBUG: _search called with remaining: ", _freq_to_string($remaining),
              " and current: [", join(" ", @$current), "]\n";
    }
    
    # If no remaining letters, we've formed a valid combination.
    if (!%$remaining) {
        print "DEBUG: Found combination: [", join(" ", @$current), "]\n" if $self->{debug};
        push @$results, [ @$current ];
        return;
    }
    
    # Stop if we've reached the maximum allowed words.
    if (scalar(@$current) >= $self->{max_words}) {
        print "DEBUG: Maximum words reached; backtracking from [", join(" ", @$current), "]\n"
            if $self->{debug};
        return;
    }
    
    # Iterate over dictionary words starting at $start_index.
    for (my $i = $start_index; $i < @{$self->{dict_words}}; $i++) {
        my $entry = $self->{dict_words}->[$i];
        if (_is_subset($entry->{freq}, $remaining)) {
            if ($self->{debug}) {
                print "DEBUG: Trying candidate word: '$entry->{word}' (normalized: '$entry->{normalized}') with freq: ",
                      _freq_to_string($entry->{freq}), "\n";
            }
            my $new_remaining = _subtract_freq($remaining, $entry->{freq});
            if ($self->{debug}) {
                print "DEBUG: New remaining after subtracting '$entry->{word}': ", _freq_to_string($new_remaining), "\n";
            }
            push @$current, $entry->{word};
            $self->_search($new_remaining, $i + 1, $current, $results);
            pop @$current;  # backtrack
        }
    }
}

# Public method to find anagrams for the given input string.
sub find_anagrams {
    my ($self, $input) = @_;
    my $normalized_input = Anagram::Dictionary::normalize_word($input);
    my $input_freq = _compute_frequency($normalized_input);
    print "DEBUG: Input '$input' normalized to '$normalized_input' with freq: ", _freq_to_string($input_freq), "\n"
        if $self->{debug};
    my @results;
    $self->_search($input_freq, 0, [], \@results);
    return \@results;
}

1;
