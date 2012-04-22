package Protocol::EMIUCP::Message::Role::Field::adc;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'adc';

use Carp qw(confess);

sub _validate_adc {
    my ($self) = @_;

    confess "Attribute (adc) is invalid"
        if defined $self->{adc} and not $self->{adc}  =~ /^\d{1,16}$/;

    return $self;
};

1;
