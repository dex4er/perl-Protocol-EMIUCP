package Protocol::EMIUCP::Message::Role::Field::Base::Num4;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

use Carp qw(confess);
use Scalar::Util qw(blessed);

sub _build_args_base_Num4 {
    my ($class, $field, $args) = @_;

    $args->{$field} = sprintf '%04d', $args->{$field}
        if defined $args->{$field} and $args->{$field} =~ /^\d{1,4}$/;

    return $class;
};

sub _validate_base_Num4 {
    my ($self, $field) = @_;

    confess "Attribute ($field) is invalid"
        if defined $self->{$field} and not $self->{$field} =~ /^\d{4}$/;

    return $self;
};

1;
