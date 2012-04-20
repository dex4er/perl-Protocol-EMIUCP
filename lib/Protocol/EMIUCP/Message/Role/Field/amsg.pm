package Protocol::EMIUCP::Message::Role::Field::amsg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has from_hex_to_utf8 from_utf8_to_hex );

has 'amsg';

sub build_args_amsg {
    my ($class, $args) = @_;

    $args->{amsg} = from_utf8_to_hex $args->{amsg_utf8}
        if defined $args->{amsg_utf8};

    return $class;
};

sub validate_amsg {
    my ($self) = @_;

    confess "Attribute (amsg) is invalid"
        if defined $self->{amsg} and not $self->{amsg} =~ /^[\dA-F]{2,640}$/;

    return $self;
};

sub amsg_utf8 {
    my ($self) = @_;
    return from_hex_to_utf8 $self->{amsg}
};

sub build_hashref_amsg {
    my ($self, $hashref) = @_;
    $hashref->{amsg_utf8} = $self->amsg_utf8 if defined $hashref->{amsg};
    return $self;
};

1;
