package Protocol::EMIUCP::Message::Role::R_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role::R);

use Carp qw(confess);

sub _build_args_r_a {
    my ($class, $args) = @_;

    $args->{nack}  = 'N' if $args->{nack};

    return $class;
};

sub _validate_r_n {
    my ($self) = @_;

    confess "Attribute (nack) is invalid, should be 'N'"
        if defined $self->{nack} and $self->{nack} ne 'N';

    return $self;
};

1;
