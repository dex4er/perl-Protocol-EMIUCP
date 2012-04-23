package Protocol::EMIUCP::Message::Role::Field::cpg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'cpg';

use Carp qw(confess);

sub _validate_cpg {
    my ($self) = @_;

    confess "Attribute (cpg) is invalid"
        if defined $self->{cpg} and not $self->{cpg} =~ /^\d$/;

    return $self;
};

1;
