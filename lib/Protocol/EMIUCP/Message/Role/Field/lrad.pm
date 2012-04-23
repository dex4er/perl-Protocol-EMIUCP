package Protocol::EMIUCP::Message::Role::Field::lrad;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'lrad';

use Carp qw(confess);

sub _validate_lrad {
    my ($self) = @_;

    confess "Attribute (lrad) is invalid"
        if defined $self->{lrad} and not $self->{lrad} =~ /^\d{1,16}$/;

    return $self;
};

1;
