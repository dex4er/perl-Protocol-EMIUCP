package Protocol::EMIUCP::Message::Role::R;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has [qw( ack nack )];

use Carp qw(confess);

sub build_args_r {
    my ($class, $args) = @_;

    $args->{o_r}  = 'R' unless defined $args->{o_r};

    return $class;
};

sub validate_r {
    my ($self) = @_;

    confess "Attribute (o_r) is invalid, should be 'R'"
        if defined $self->{o_r} and $self->{o_r} ne 'R';
    confess "Attribute (ack) or attribute (nack) is required"
        unless $self->{ack} or $self->{nack};

    return $self;
};

1;
