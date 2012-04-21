package Protocol::EMIUCP::Message::Role::Field::mms;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'mms';

use Carp qw(confess);

sub validate_mms {
    my ($self) = @_;

    confess "Attribute (mms) is invalid"
        if defined $self->{mms} and not $self->{mms} =~ /^\d$/;

    return $self;
};

1;
