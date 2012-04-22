package Protocol::EMIUCP::Message::Role::Field::tmsg;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'tmsg';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( decode_hex encode_hex );

sub _build_args_tmsg {
    my ($class, $args) = @_;

    $args->{tmsg} = encode_hex $args->{tmsg_binary}
        if defined $args->{tmsg_binary};

    $args->{nb} = 4 * length $args->{tmsg}  # one char from tmsg is 4 bits
        if not defined $args->{nb} and defined $args->{tmsg};

    return $class;
};

sub _validate_tmsg {
    my ($self) = @_;

    confess "Attribute (tmsg) is invalid"
        if defined $self->{tmsg} and not $self->{tmsg} =~ /^[\dA-F]{2,1403}$/;

    confess "Attribute (tmsg) is invalid, should be undefined if mt != 4"
        if defined $self->{mt} and $self->{mt} != 4 and defined $self->{tmsg};

    return $self;
};

sub tmsg_binary {
    my ($self) = @_;
    return decode_hex $self->{tmsg}
};

sub _build_hashref_tmsg {
    my ($self, $hashref) = @_;
    $hashref->{tmsg_binary} = $self->tmsg_binary if defined $hashref->{tmsg};
    return $self;
};

1;
