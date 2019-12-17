package Perlis::Shape::T;

use strict;
use warnings;

use parent 'Perlis::Shape';

sub initial_coords {
    my ($self, $columns) = @_;
    my $start = $self->_rand_between(0, $columns-2);
    return [
        [ $start,   0 ],
        [ $start+1, 0 ],
        [ $start+1, 1 ],
        [ $start+2, 0 ],
    ];
}

sub id {
    my ($self) = @_;

    return 4;
}

sub rotate {
    my ($self) = @_;
    return;
}

1;
