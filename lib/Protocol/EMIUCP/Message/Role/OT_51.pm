package Protocol::EMIUCP::Message::Role::OT_51;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role::OT_5x);

use Carp qw(confess);

sub _build_args_ot_51 {
    my ($class, $args) = @_;

    $args->{ot} = '51' unless defined $args->{ot};

    return $class;
};

sub _validate_ot_51 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '51'"
        if defined $self->{ot} and $self->{ot} ne '51';

    return $self;
};

1;
