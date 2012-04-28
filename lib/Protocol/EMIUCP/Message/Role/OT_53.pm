package Protocol::EMIUCP::Message::Role::OT_53;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role::OT_50);

use Carp qw(confess);

sub _build_args_ot_53 {
    my ($class, $args) = @_;

    $args->{ot} = '53' unless defined $args->{ot};

    return $class;
};

sub _validate_ot_53 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '53'"
        if defined $self->{ot} and $self->{ot} ne '53';

    return $self;
};

1;
