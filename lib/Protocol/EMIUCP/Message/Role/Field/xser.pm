package Protocol::EMIUCP::Message::Role::Field::xser;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'xser';

use Carp qw(confess);

sub _validate_xser {
    my ($self) = @_;

    confess "Attribute (xser) is invalid"
        if defined $self->{xser} and not $self->{xser} =~ /^\d{1,400}$/;

    return $self;
};

1;
