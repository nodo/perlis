#!/usr/bin/env perl -Ilib

use strict;
use warnings;

use feature 'say';
use Time::HiRes qw(usleep);

use Perlis::Game;

my $rows    = 20;
my $columns = 10;

my $game = Perlis::Game->new( $columns, $rows );

while (1) {
    my $success = $game->tick();
    if (!$success) {
        say 'DONE';
        exit 0;
    }
    $game->show();
    usleep(100000);
}
