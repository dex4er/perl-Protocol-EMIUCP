package Protocol::EMIUCP::Message::Role::R_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::R
    Protocol::EMIUCP::Message::Role
);

use Carp qw(confess);

sub build_args_r_a {
    my ($class, $args) = @_;

    $args->{ack}  = 'A' if $args->{ack};

    return $class
        ->build_args_r($args);
};

sub validate_r_a {
    my ($self) = @_;

    confess "Attribute (ack) is invalid, should be 'A'"
        if defined $self->{ack} and $self->{ack} ne 'A';

    return $self
        ->validate_r;
};

1;
