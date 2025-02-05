#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Mojolicious::Lite -signatures;
use lib 'lib';
use Encode qw(decode_utf8 encode_utf8 is_utf8);
use JSON::PP;
use Anagram::Solver;
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

# Initialize the solver
my $solver = Anagram::Solver->new();

# Configure for UTF-8
app->renderer->encoding('UTF-8');

# Enable CORS
app->hook(before_dispatch => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => 'http://localhost:5173');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type');
});

# Handle OPTIONS
options '/*' => sub ($c) { $c->rendered(204) };

# Helper for debugging text
sub debug_text {
    my ($text) = @_;
    my @chars = split(//, $text);
    return {
        original => $text,
        is_utf8 => is_utf8($text) ? 1 : 0,
        length => length($text),
        bytes => join(' ', map { sprintf("%04X", ord($_)) } @chars),
        chars => [map { { char => $_, code => sprintf("%04X", ord($_)) } } @chars]
    };
}

# Anagram endpoint
post '/api/anagram' => sub ($c) {
    my $error;
    my $result = eval {
        # Get input
        my $json = $c->req->json;
        my $raw_text = $json->{text} // '';
        
        # Debug raw input
        my $raw_debug = debug_text($raw_text);
        
        # Decode if not already UTF-8
        my $text = $raw_text;
        if (!is_utf8($text)) {
            $text = decode_utf8($raw_text);
        }
        
        # Debug decoded text
        my $decoded_debug = debug_text($text);
        
        # Find anagrams using the solver
        my $anagrams = $solver->find_anagrams($text);
        
        return { 
            results => $anagrams,
            debug => {
                raw => $raw_debug,
                decoded => $decoded_debug
            }
        };
    };
    
    if ($@) {
        $error = $@;
        app->log->error("Error processing request: $error");
        return $c->render(json => { 
            error => "Internal server error",
            debug => { 
                error => "$error",
                raw_text => $c->req->json->{text}
            }
        }, status => 500);
    }
    
    $c->render(json => $result);
};

app->start('daemon', '-l', 'http://*:3000');
