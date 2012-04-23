package Protocol::EMIUCP::Message::Role::Field::nrq;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'nrq';

use Carp qw(confess);

sub _build_args_nrq {
    my ($class, $args) = @_;

    $args->{nrq}  = 0
        if defined $args->{nrq} and not $args->{nrq};

    return $class;
};

sub _validate_nrq {
    my ($self) = @_;

    confess "Attribute (nrq) is invalid"
        if defined $self->{nrq} and not $self->{nrq} =~ /^[01]$/;

    return $self;
};

1;
