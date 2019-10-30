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
    $self->delete_completed_lines();
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

    if ($self->{listener}) {
        my $key = $self->{listener}->read_key();
        $self->dispatch($key) if defined $key;
    }

    $self->clear();
    $self->draw_shapes();
    my $success = $self->apply_gravity();
    if ( !$success ) {
        my $added = $self->add_shape();
        return 0 if !$added;
    }
    $self->clear();
    $self->draw_shapes();

    return 1;
}

sub delete_completed_lines {
    my ($self) = @_;

    my $lowest_deleted_line;
    for (my $i = 0; $i < $self->{rows}; $i++) {
        my $rowref = $self->{grid}->[$i];
        my $out = grep { $_ == 0 } @$rowref;
        if (!$out) {
            $self->delete_row($i);
            $lowest_deleted_line = $i;
        }
    }
    if ($lowest_deleted_line) {
        $self->consolidate();
    }
}

sub delete_row {
    my ($self, $r) = @_;

    for (my $c = 0; $c < $self->{columns}; $c++) {
        foreach my $shape ( @{ $self->{frozen_shapes} } ) {
            $self->{grid}->[$r]->[$c] = 0;
            $shape->cancel($c, $r);
        }
    }
}

sub attach_listener {
    my ($self, $listener) = @_;

    $self->{listener} = $listener;

}

sub dispatch {
    my ($self, $key) = @_;

    if ($key eq "a") {
        $self->{active}->left;
    } elsif ($key eq "d") {
        $self->{active}->right;
    }
}

sub draw_shapes {
    my ($self) = @_;

    $self->{active}->draw() if $self->{active};
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

sub consolidate {
    my ($self) = @_;

    $self->clear();
    $self->draw_shapes();
    my $moved;
    do {
        $moved = 0;
        foreach my $shape ( @{ $self->{frozen_shapes} } ) {
            next if $shape->empty;

            my $result = $shape->down();
            $moved ||= $result;
            $self->clear();
            $self->draw_shapes();
        }
    } while ($moved);
}

1;
