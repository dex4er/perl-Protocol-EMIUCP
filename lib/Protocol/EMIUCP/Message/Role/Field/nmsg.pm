package Protocol::EMIUCP::Message::Role::Field::nmsg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has );

has 'nmsg';

sub validate_nmsg {
    my ($self) = @_;

    confess "Attribute (nmsg) is invalid"
        if defined $self->{nmsg} and not $self->{nmsg} =~ /^\d{1,160}$/;

    return $self;
};

1;
