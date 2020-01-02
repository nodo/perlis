package Perlis::Utils;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(
    log
);

sub log {
    my ($msg) = @_;

    print STDERR "$msg\n";
}

1;
