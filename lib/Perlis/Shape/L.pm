package Perlis::Shape::L;

use strict;
use warnings;

use parent 'Perlis::Shape';

sub initial_coords {
    my ($self, $columns) = @_;
    my $start = $self->_rand_between(0, $columns-1);
    return [
        [ $start+1, 0 ],
        [ $start, 1 ],
        [ $start+1, 1 ],
    ];
}

sub id {
    my ($self) = @_;

    return 1;
}

sub rotate {
    my ($self) = @_;
    $self->{rotation_count} //= 0;

    if ($self->{rotation_count} % 4 == 0) {
        $self->{coords}->[0][0]--;
    } elsif ($self->{rotation_count} % 4 == 1) {
        $self->{coords}->[2][1]--;
    } elsif ($self->{rotation_count} % 4 == 2) {
        $self->{coords}->[1][0]++;
    } else {
        $self->{coords}->[1][0]--;
        $self->{coords}->[2][1]++;
        $self->{coords}->[0][0]++;
    }
    $self->{rotation_count}++;

    return;
}

1;
