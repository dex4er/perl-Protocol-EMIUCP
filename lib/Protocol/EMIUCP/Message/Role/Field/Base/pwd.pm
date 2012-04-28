package Protocol::EMIUCP::Message::Role::Field::Base::pwd;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'pwd';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_hex_to_utf8 from_utf8_to_hex );

sub _build_args_base_pwd {
    my ($class, $field, $args) = @_;

    my $field_utf8 = "${field}_utf8";
    $args->{$field} = from_utf8_to_hex $args->{$field_utf8}
        if defined $args->{$field_utf8};

    return $class;
};

sub _validate_base_pwd {
    my ($self, $field) = @_;

    confess "Attribute (pwd) is invalid"
        if defined $self->{$field} and not $self->{$field} =~ /^[\dA-F]{1,16}$/;

    return $self;
};

sub _base_pwd_utf8 {
    my ($self, $field) = @_;
    return from_hex_to_utf8 $self->{$field}
};

sub _build_hashref_base_pwd {
    my ($self, $field, $hashref) = @_;
    my $field_utf8 = "${field}_utf8";
    $hashref->{$field_utf8} = $self->$field_utf8 if defined $hashref->{$field};
    return $self;
};

1;
