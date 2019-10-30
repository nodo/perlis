#!/usr/bin/env perl -Ilib

use strict;
use warnings;

use feature 'say';
use Time::HiRes qw(usleep);

use Perlis::Game;
use Perlis::CLIRenderer;

my $rows    = 20;
my $columns = 15;

my $game = Perlis::Game->new( $columns, $rows );

while (1) {
    my $success = $game->tick();
    if (!$success) {
        say 'You lost.';
        exit 0;
    }
    Perlis::CLIRenderer::do($game);
    usleep(100000);
}
