#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use File::Path qw(make_path);
use File::Spec;
use Cwd qw(abs_path);

# Determine the base directory.
# This script assumes it is run from the "setup" folder and that the app folder
# is the parent directory of the current working directory.
my $setup_dir = abs_path('.');
my $base_dir  = File::Spec->catdir($setup_dir, '..');

print "Using base directory: $base_dir\n";

# Define the directory structure relative to the base directory.
my @dirs = (
    'bin',
    'lib/Anagram',
    't',
    'data',
    'docs',
);

# Create each directory if it doesn't already exist.
foreach my $dir (@dirs) {
    my $full_dir = File::Spec->catdir($base_dir, $dir);
    unless (-d $full_dir) {
        make_path($full_dir) or die "Cannot create directory $full_dir: $!";
        print "Created directory: $full_dir\n";
    } else {
        print "Directory already exists: $full_dir\n";
    }
}

# Define files to create (with minimal placeholder content).
my %files = (
    'README.md' => <<'EOF',
# AnagramGPT

This is the AnagramGPT project.
EOF

    'bin/anagram_solver.pl' => <<'EOF',
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

# TODO: Implement the command-line anagram solver.
print "Anagram solver coming soon!\n";
EOF

    'lib/Anagram/Dictionary.pm' => <<'EOF',
package Anagram::Dictionary;
use strict;
use warnings;
use utf8;

# TODO: Implement dictionary loading, normalization, etc.

1;
EOF

    'lib/Anagram/Solver.pm' => <<'EOF',
package Anagram::Solver;
use strict;
use warnings;
use utf8;

# TODO: Implement the anagram-solving logic (including multi-word support).

1;
EOF

    'data/hebrew_dict.txt' => <<'EOF',
# TODO: Add Hebrew dictionary words here.
EOF

    't/basic.t' => <<'EOF',
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Test::More tests => 1;

# TODO: Add tests for the AnagramGPT modules.
ok(1, 'Placeholder test');

EOF
);

# Create (or overwrite) the files with the placeholder content.
foreach my $rel_path (keys %files) {
    my $full_path = File::Spec->catfile($base_dir, $rel_path);
    
    # Ensure the directory for the file exists.
    my (undef, $dirs, undef) = File::Spec->splitpath($full_path);
    if ($dirs and ! -d $dirs) {
        make_path($dirs) or die "Cannot create directory $dirs: $!";
    }
    
    # Write the placeholder content.
    open my $fh, '>:encoding(UTF-8)', $full_path
      or die "Cannot open $full_path for writing: $!";
    print $fh $files{$rel_path};
    close $fh;
    
    # If the file is a script, you might want to make it executable.
    if ($rel_path =~ m{^(bin/|t/)} && $^O ne 'MSWin32') {
        chmod 0755, $full_path or warn "Couldn't chmod $full_path: $!";
    }
    
    print "Created file: $full_path\n";
}

print "\nProject scaffold created successfully in $base_dir\n";
