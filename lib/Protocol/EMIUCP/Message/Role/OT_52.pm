package Protocol::EMIUCP::Message::Role::OT_52;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role::OT_50);

use Carp qw(confess);

sub _build_args_ot_52 {
    my ($class, $args) = @_;

    $args->{ot} = '52' unless defined $args->{ot};

    return $class;
};

sub _validate_ot_52 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '52'"
        if defined $self->{ot} and $self->{ot} ne '52';

    return $self;
};

1;
