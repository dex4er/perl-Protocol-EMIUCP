package Protocol::EMIUCP::Message::Role::Field::tmsg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has decode_hex encode_hex );

has 'tmsg';

sub build_tmsg_args {
    my ($class, $args) = @_;

    $args->{tmsg} = encode_hex $args->{tmsg_binary}
        if defined $args->{tmsg_binary};

    return $class;
};

sub validate_tmsg {
    my ($self) = @_;

    confess "Attribute (tmsg) is invalid"
        if defined $self->{tmsg} and not $self->{tmsg} =~ /^[\dA-F]{2,1403}$/;

    return $self;
};

sub tmsg_binary {
    my ($self) = @_;
    return decode_hex $self->{tmsg}
};

sub build_tmsg_hashref {
    my ($self, $hashref) = @_;
    $hashref->{tmsg_binary} = $self->tmsg_binary if defined $hashref->{tmsg};
    return $self;
};

1;
