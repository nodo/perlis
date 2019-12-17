package Perlis::Shape::Bar;

use strict;
use warnings;

use parent 'Perlis::Shape';

sub initial_coords {
    my ($self, $columns) = @_;
    my $start = $self->_rand_between(0, $columns-2);
    return [
        [ $start, 0 ],
        [ $start+1, 0 ],
        [ $start+2, 0 ],
    ];
}

sub id {
    my ($self) = @_;

    return 3;
}

sub rotate {
    my ($self) = @_;

    $self->{rotation_count} //= 0;

    my $center = $self->{coords}->[1];
    if ($self->{rotation_count} % 2 == 0) {
        # Current shape is horizontal
        $self->{coords}->[0] = [$center->[0], $center->[1]-1];
        $self->{coords}->[2] = [$center->[0], $center->[1]+1];
    } else {
        # Current shape is vertical
        $self->{coords}->[0] = [$center->[0]-1, $center->[1]];
        $self->{coords}->[2] = [$center->[0]+1, $center->[1]];
    }
    $self->{rotation_count}++;
}

1;
