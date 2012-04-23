package Protocol::EMIUCP::Message::Role::Field::oadc_num;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'oadc';

use Carp qw(confess);

sub _validate_oadc_num {
    my ($self) = @_;

    confess "Attribute (oadc) is invalid"
        if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}$/;

    return $self;
};

1;
