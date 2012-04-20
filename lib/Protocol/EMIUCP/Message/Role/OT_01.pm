package Protocol::EMIUCP::Message::Role::OT_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);

sub build_args_ot_01 {
    my ($class, $args) = @_;

    $args->{ot} = '01' unless defined $args->{ot};

    return $class;
};

sub validate_ot_01 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '01'"
        if defined $self->{ot}   and $self->{ot} ne '01';

    return $self;
};

1;
