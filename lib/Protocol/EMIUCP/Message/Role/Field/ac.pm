package Protocol::EMIUCP::Message::Role::Field::ac;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'ac';

use Carp qw(confess);

sub _validate_ac {
    my ($self) = @_;

    confess "Attribute (ac) is invalid"
        if defined $self->{ac} and not $self->{ac} =~ /^\d{4,16}$/;

    return $self;
};

1;
