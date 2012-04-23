package Protocol::EMIUCP::Message::Role::Field::dd;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'dd';

use Carp qw(confess);

sub _build_args_dd {
    my ($class, $args) = @_;

    $args->{dd}  = 0
        if defined $args->{dd} and not $args->{dd};

    return $class;
};

sub _validate_dd {
    my ($self) = @_;

    confess "Attribute (dd) is invalid"
        if defined $self->{dd} and not $self->{dd} =~ /^[01]$/;

    return $self;
};

1;
