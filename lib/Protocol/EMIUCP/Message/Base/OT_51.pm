package Protocol::EMIUCP::Message::Base::OT_51;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Base::OT_50);

use Carp qw(confess);

sub build_ot_51_args {
    my ($class, $args) = @_;

    $args->{ot} = '51' unless defined $args->{ot};

    return $class;
};

sub validate_ot_51 {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '51'"
        if defined $self->{ot}   and $self->{ot} ne '51';

    return $self;
};

1;
