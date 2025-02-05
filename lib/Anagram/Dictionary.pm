package Anagram::Dictionary;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, %args) = @_;
    # Use a relative path; this will be relative to the current working directory.
    my $self = {
        dict_file => $args{dict_file} || "data/hebrew_dict.txt",
        words     => [],
    };
    bless $self, $class;
    $self->_load_dictionary();
    return $self;
}

sub _load_dictionary {
    my ($self) = @_;
    open my $fh, '<:encoding(UTF-8)', $self->{dict_file}
      or die "Cannot open dictionary file '$self->{dict_file}': $!";
    while (<$fh>) {
        chomp;
        next if /^#/;  # ignore comment lines
        push @{ $self->{words} }, $_;
    }
    close $fh;
}

sub get_words {
    my ($self) = @_;
    return $self->{words};
}

# Normalize a Hebrew word by mapping final-letter forms (אותיות סופיות) to their standard forms.
sub normalize_word {
    my ($word) = @_;
    my %final_map = (
       'ך' => 'כ',
       'ם' => 'מ',
       'ן' => 'נ',
       'ף' => 'פ',
       'ץ' => 'צ',
    );
    my $normalized = "";
    for my $char (split //, $word) {
         $normalized .= exists $final_map{$char} ? $final_map{$char} : $char;
    }
    return $normalized;
}

1;
