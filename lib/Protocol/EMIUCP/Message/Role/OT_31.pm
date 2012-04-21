package Protocol::EMIUCP::Message::Role::OT_31;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role);

use Carp qw(confess);

sub build_args_ot_31 {
    my ($class, $args) = @_;

    $args->{ot} = '31' unless defined $args->{ot};

    return $class;
};

sub validate_ot_31 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '31'"
        if defined $self->{ot}   and $self->{ot} ne '31';

    return $self;
};

1;
