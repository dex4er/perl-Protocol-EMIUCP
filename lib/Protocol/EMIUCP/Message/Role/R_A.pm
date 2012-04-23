package Protocol::EMIUCP::Message::Role::R_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role::R);

use Carp qw(confess);

sub _build_args_r_a {
    my ($class, $args) = @_;

    $args->{ack} = 'A' if $args->{ack};
    delete $args->{ack} if defined $args->{ack} and not $args->{ack};

    return $class;
};

sub _validate_r_a {
    my ($self) = @_;

    confess "Attribute (ack) is invalid, should be 'A'"
        if defined $self->{ack} and $self->{ack} ne 'A';

    return $self;
};

1;
