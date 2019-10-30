#!/usr/bin/env perl -Ilib

use strict;
use warnings;

use feature 'say';
use Time::HiRes qw(usleep);

use Perlis::Game;
use Perlis::CLIRenderer;
use Perlis::KeyListener;

use Term::ReadKey;

my $rows    = 20;
my $columns = 15;

my $game = Perlis::Game->new( $columns, $rows );
my $listener = Perlis::KeyListener->new();

$game->attach_listener($listener);

while (1) {
    my $success = $game->tick();
    if (!$success) {
        say 'You lost.';
        exit 0;
    }
    read_key();
    Perlis::CLIRenderer::do($game);
    usleep(100000);
}

sub read_key {
    ReadMode 4;
    my $key = ReadKey(-1);
    print STDERR "Pressed $key\n" if defined $key;
    ReadMode 0;
}
