package Perlis::Shape;

use strict;
use warnings;

use feature 'say';
use Data::Dump 'pp';

sub new {
    my ( $class, $grid ) = @_;

    my $columns = scalar(@{$grid->[0]});

    my $self = {
        grid   => $grid,
    };
    bless $self, $class;
    $self->{coords} = $self->initial_coords($columns);
    return $self;
}

sub draw {
    my ($self) = @_;

    foreach my $coord ( $self->{coords}->@* ) {
        my $c = $coord->[0];
        my $r = $coord->[1];

        if ($self->{grid}->[$r]->[$c] != 0) {
            return 0;
        }
        $self->{grid}->[$r]->[$c] = $self->id;
    }
    return 1;
}

sub down {
    my ($self) = @_;

    my $new_coords;
    foreach my $coord ( $self->{coords}->@* ) {
        my $c = $coord->[0];
        my $r = $coord->[1];

        my $new_coord = [ $c, $r + 1 ];
        if ( $self->_collision($new_coord) ) {
            return 0;
        }
        push( @$new_coords, $new_coord );
    }

    # If you are here none of the new coordinates collide
    # with borders or frozen shapes. You are good to go.
    $self->{coords} = $new_coords;

    return 1;
}

sub _collision {
    my ( $self, $new_coord ) = @_;

    my $grid = $self->{grid};

    my $c = $new_coord->[0];
    my $r = $new_coord->[1];

    return 1 if ( $r < 0 || $r > scalar(@$grid) - 1 );
    return 1 if ( $c < 0 || $c > scalar( @{ $grid->[0] } ) - 1 );

    return 0 if $self->{grid}->[$r]->[$c] == 0;

    return 0 if $self->_old_coords_contains_new_coord($new_coord);

    return 1;
}

sub _old_coords_contains_new_coord {
    my ( $self, $new_coord ) = @_;

    foreach my $coord ( $self->{coords}->@* ) {
        if ( $new_coord->[0] == $coord->[0] && $new_coord->[1] == $coord->[1] ) {
            return 1;
        }
    }
    return 0;
}

# Random integer in [$minimum, $maximum)
sub _rand_between {
    my ($self, $minimum, $maximum) = @_;

    return $minimum + int(rand($maximum - $minimum));
}

1;
