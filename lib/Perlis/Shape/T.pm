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
        [ $start+2, 0 ],
        [ $start+1, 1 ],
    ];
}

sub id {
    my ($self) = @_;

    return 4;
}

sub rotate {
    my ($self) = @_;
    $self->{rotation_count} //= 0;

    if ($self->{rotation_count} % 4 == 0) {
        $self->{coords}->[2][0]--;
        $self->{coords}->[2][1]--;
    } elsif ($self->{rotation_count} % 4 == 1) {
        $self->{coords}->[3][0]++;
        $self->{coords}->[3][1]--;
    } elsif ($self->{rotation_count} % 4 == 2) {
        $self->{coords}->[0][0]++;
        $self->{coords}->[0][1]++;
    } else {
        $self->{coords}->[0][0]--;
        $self->{coords}->[0][1]--;
        $self->{coords}->[2][0]++;
        $self->{coords}->[2][1]++;
        $self->{coords}->[3][0]--;
        $self->{coords}->[3][1]++;
    }
    $self->{rotation_count}++;

    return;
}

1;
