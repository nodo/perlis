package Perlis::CLIRenderer;

use strict;
use warnings;

use feature 'say';

sub do {
    my ($game) = @_;

    say "\033[2J\033[H";
    say  "\033[47m" . ' ' x  ($game->{columns} + 2) . "\033[0m" ;
    foreach ( @{ $game->{grid} } ) {
        my @colorised = map {
            $_ == 0 ? ' ' :
              $_ == 1 ? blue(' ') :
              $_ == 2 ? red(' ') :
              $_ == 3 ? green(' ') : yellow(' ')
        } @$_;
        say "\033[47m \033[0m" . join( '', @colorised) . "\033[47m \033[0m" ;
    }
    say  "\033[47m" . ' ' x  ($game->{columns} + 2) . "\033[0m" ;
}

sub red {
    my ($str) = @_;

    return "\033[41m".$str."\033[0m";
}

sub white {
    my ($str) = @_;

    return "\033[37m".$str."\033[0m";
}

sub green {
    my ($str) = @_;

    return "\033[42m".$str."\033[0m";
}

sub blue {
    my ($str) = @_;

    return "\033[44m".$str."\033[0m";
}

sub yellow {
    my ($str) = @_;

    return "\033[43m".$str."\033[0m";
}

1;
