package Protocol::EMIUCP::Message::Role::Field::lrq;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'lrq';

use Carp qw(confess);

sub _build_args_lrq {
    my ($class, $args) = @_;

    $args->{lrq}  = 0
        if defined $args->{lrq} and not $args->{lrq};

    return $class;
};

sub _validate_lrq {
    my ($self) = @_;

    confess "Attribute (lrq) is invalid"
        if defined $self->{lrq} and not $self->{lrq} =~ /^[01]$/;

    return $self;
};

1;
