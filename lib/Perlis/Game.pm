package Perlis::Game;

use strict;
use warnings;

use feature 'say';
use Data::Dump 'pp';

use Perlis::Shape;
use Perlis::Shape::Box;
use Perlis::Shape::Bar;
use Perlis::Shape::L;

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

    my %shapes = (
        'Perlis::Shape::Bar' => 1,
        'Perlis::Shape::Box' => 1,
        'Perlis::Shape::L' => 1,

    );
    my @keys = keys(%shapes);
    my $shape_type = $keys[0];
    my $shape = eval "$shape_type->new( \$self->{grid} )";
    # Perlis::Shape::Box->new( $self->{grid} );
    # }
    $self->{active} = $shape;

}

sub show {
    my ($self) = @_;

    say "\033[2J\033[H";
    say '-' x ($self->{columns}*2);
    foreach ( @{ $self->{grid} } ) {
        say '|'.join( ' ', map { $_ == 0 ? ' ' : 'X' } @$_ ).'|';
    }
    say '-' x ($self->{columns}*2);
}

sub tick {
    my ($self) = @_;

    $self->{previous_state} = _hash_state($self->{grid});
    my $success = $self->apply_gravity();
    if ( !$success ) {
        $self->add_shape();
    }
    $self->clear();
    $self->draw_shapes();

    return 0 if $self->end_of_game();
    return 1;
}


sub end_of_game {
    my ($self) = @_;

    my $new_state_hash = _hash_state($self->{grid});
    return $self->{previous_state} eq $new_state_hash;
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

sub _hash_state {
    my ($grid) = @_;

    my $str;
    foreach my $row (@$grid) {
        $str .= join('', @$row);
    }

    return $str;
}

1;
