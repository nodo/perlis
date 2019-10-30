package Perlis::Game;

use strict;
use warnings;

use feature 'say';
use Data::Dump 'pp';

use Perlis::Shape;
use Perlis::Shape::Box;
use Perlis::Shape::Bar;
use Perlis::Shape::L;
use Perlis::Shape::T;

sub new {
    my ( $class, $columns, $rows ) = @_;

    my $grid;
    for ( my $i = 0; $i < $rows; $i++ ) {
        my @row;
        for ( my $j = 0; $j < $columns; $j++ ) {
            push @row, 0;
        }
        push @$grid, \@row;
    }

    my $game = {
        columns => $columns,
        rows    => $rows,
        grid    => $grid,
    };

    bless $game, $class;
    $game->add_shape();

    return $game;
}

sub add_shape {
    my ($self) = @_;

    if ( $self->{active} ) {
        push @{ $self->{frozen_shapes} }, $self->{active};
        $self->{active} = undef;
    }

    my @shapes = (
        'Perlis::Shape::Bar',
        'Perlis::Shape::Box',
        'Perlis::Shape::L',
        'Perlis::Shape::T',
    );
    my $shape_type = $shapes[rand(@shapes)];
    my $shape      = eval "$shape_type->new( \$self->{grid} )";
    $self->{active} = $shape;
    return $shape->draw();
}

sub tick {
    my ($self) = @_;

    my $success = $self->apply_gravity();
    if ( !$success ) {
        my $added = $self->add_shape();
        return 0 if !$added;
    }
    $self->clear();
    $self->draw_shapes();

    return 1;
}

sub draw_shapes {
    my ($self) = @_;

    $self->{active}->draw();
    foreach my $shape ( @{ $self->{frozen_shapes} } ) {
        $shape->draw();
    }
}

sub clear {
    my ($self) = @_;

    for ( my $r = 0; $r < $self->{rows}; $r++ ) {
        for ( my $c = 0; $c < $self->{columns}; $c++ ) {
            $self->{grid}->[$r]->[$c] = 0;
        }
    }
}

sub apply_gravity {
    my ($self) = @_;

    my $active_shape = $self->{active};
    my $success      = $active_shape->down();
    return $success;
}

1;
