package Protocol::EMIUCP::Message::Role::Field::pr;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'pr';

use Carp qw(confess);

sub _validate_pr {
    my ($self) = @_;

    confess "Attribute (pr) is invalid"
        if defined $self->{pr} and not $self->{pr} =~ m{^ [^/] $}x;

    return $self;
};

1;
