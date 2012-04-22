package Protocol::EMIUCP::Message::Role::Field::nb;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'nb';

use Carp qw(confess);

sub validate_nb {
    my ($self) = @_;

    confess "Attribute (nb) is invalid"
        if defined $self->{nb} and not $self->{nb} =~ /^\d{1,4}$/;

    if (defined $self->{mt} and $self->{mt} == 4) {
        confess "Attribute (nb) is required"
            unless defined $self->{nb};
        # TODO mcl is required if XSer "GSM DCS information" is not supplied
    };

    return $self;
};

1;
