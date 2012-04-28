package Protocol::EMIUCP::Message::Role::OT_60;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role::OT_6x);

use Carp qw(confess);

sub _build_args_ot_60 {
    my ($class, $args) = @_;

    $args->{ot} = '60' unless defined $args->{ot};

    return $class;
};

sub _validate_ot_60 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '60'"
        if defined $self->{ot} and $self->{ot} ne '60';

    return $self;
};

1;
