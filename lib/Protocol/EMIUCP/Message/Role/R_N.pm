package Protocol::EMIUCP::Message::Role::R_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role::R);

use Carp qw(confess);

sub build_r_a_args {
    my ($class, $args) = @_;

    $args->{nack}  = 'N' if $args->{nack};

    return $class
        ->build_r_args($args);
};

sub validate_r_n {
    my ($self) = @_;

    confess "Attribute (nack) is invalid, should be 'N'"
        if defined $self->{nack} and $self->{nack} ne 'N';

    return $self
        ->validate_r;
};

1;