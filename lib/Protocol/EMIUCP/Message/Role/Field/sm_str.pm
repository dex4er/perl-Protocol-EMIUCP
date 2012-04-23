package Protocol::EMIUCP::Message::Role::Field::sm_str;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'sm';

use Carp qw(confess);

sub _validate_sm_str {
    my ($self) = @_;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and $self->{sm} =~ m{/};

    return $self;
};

1;
