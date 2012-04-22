package Protocol::EMIUCP::Message::Role::O;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

use Carp qw(confess);

sub _build_args_o {
    my ($class, $args) = @_;

    $args->{o_r} = 'O' unless defined $args->{o_r};

    return $class;
};

sub _validate_o {
    my ($self) = @_;

    confess "Attribute (o_r) is invalid, should be 'O'"
        if defined $self->{o_r} and $self->{o_r} ne 'O';

    return $self;
};

1;
