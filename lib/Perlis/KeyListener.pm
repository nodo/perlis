package Perlis::KeyListener;

use strict;
use warnings;

use Term::ReadKey;

sub new {
    my ($class) = @_;
    my $self = {};
    bless $self, $class;
    return $self
}

sub read_key {
    my ($self) = @_;

    ReadMode 4;
    my $key = ReadKey(-1);
    ReadMode 0;

    return $key;
}

1;
