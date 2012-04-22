package Protocol::EMIUCP::Message::Role::Field::nmsg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'nmsg';

use Carp qw(confess);

sub _validate_nmsg {
    my ($self) = @_;

    confess "Attribute (nmsg) is invalid"
        if defined $self->{nmsg} and not $self->{nmsg} =~ /^\d{1,160}$/;

    confess "Attribute (nmsg) is invalid, should be undefined if mt != 2"
        if defined $self->{mt} and $self->{mt} ne 2 and defined $self->{nmsg};

    return $self;
};

1;
