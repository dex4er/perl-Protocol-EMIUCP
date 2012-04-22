package Protocol::EMIUCP::Message::Role::Field::mcls;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'mcls';

use Carp qw(confess);

sub _validate_mcls {
    my ($self) = @_;

    confess "Attribute (mcls) is invalid"
        if defined $self->{mcls} and not $self->{mcls} =~ /^[0-3]$/;

    return $self;
};

1;
