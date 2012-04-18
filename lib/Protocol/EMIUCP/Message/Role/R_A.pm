package Protocol::EMIUCP::Message::Role::R_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role::R);

use Carp qw(confess);

sub build_r_a_args {
    my ($class, $args) = @_;

    $args->{ack}  = 'A' if $args->{ack};

    return $class
        ->build_r_args($args);
};

sub validate_r_a {
    my ($self) = @_;

    confess "Attribute (ack) is invalid, should be 'A'"
        if defined $self->{ack} and $self->{ack} ne 'A';

    return $self
        ->validate_r;
};

1;
