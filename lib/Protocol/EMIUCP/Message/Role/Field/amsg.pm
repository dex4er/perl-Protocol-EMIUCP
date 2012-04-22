package Protocol::EMIUCP::Message::Role::Field::amsg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'amsg';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_hex_to_utf8 from_utf8_to_hex );

sub _build_args_amsg {
    my ($class, $args) = @_;

    $args->{amsg} = from_utf8_to_hex $args->{amsg_utf8}
        if defined $args->{amsg_utf8};

    return $class;
};

sub _validate_amsg {
    my ($self) = @_;

    confess "Attribute (amsg) is invalid"
        if defined $self->{amsg} and not $self->{amsg} =~ /^[\dA-F]{2,640}$/;

    confess "Attribute (amsg) is invalid, should be undefined if mt != 3"
        if defined $self->{mt} and $self->{mt} ne 3 and defined $self->{amsg};

    return $self;
};

sub amsg_utf8 {
    my ($self) = @_;
    return from_hex_to_utf8 $self->{amsg}
};

sub _build_hashref_amsg {
    my ($self, $hashref) = @_;
    $hashref->{amsg_utf8} = $self->amsg_utf8 if defined $hashref->{amsg};
    return $self;
};

1;
