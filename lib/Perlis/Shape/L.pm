package Perlis::Shape::L;

use strict;
use warnings;

use parent 'Perlis::Shape';

sub initial_coords {
    my ($self, $columns) = @_;
    my $start = $self->_rand_between(0, $columns-1);
    return [
        [ $start, 1 ],
        [ $start+1, 0 ],
        [ $start+1, 1 ],
    ];
}

1;
