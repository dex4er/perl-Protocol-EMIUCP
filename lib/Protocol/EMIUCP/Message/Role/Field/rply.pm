package Protocol::EMIUCP::Message::Role::Field::rply;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'rply';

use Carp qw(confess);

sub _validate_rply {
    my ($self) = @_;

    confess "Attribute (rply) is invalid"
        if defined $self->{rply} and not $self->{rply} =~ /^\d$/;

    return $self;
};

1;
