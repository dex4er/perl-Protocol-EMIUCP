package Protocol::EMIUCP::Message::Role::Field::hplmn;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'hplmn';

use Carp qw(confess);

sub _validate_hplmn {
    my ($self) = @_;

    confess "Attribute (hplmn) is invalid"
        if defined $self->{hplmn} and not $self->{hplmn} =~ /^\d{1,16}$/;

    return $self;
};

1;
