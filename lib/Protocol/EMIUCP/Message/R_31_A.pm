package Protocol::EMIUCP::Message::R_31_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::R_A
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(has);

has 'sm';

use constant list_data_field_names => [ qw( ack sm ) ];

sub build_args {
    my ($class, $args) = @_;

    $class->SUPER::build_args($args);

    $args->{sm} = sprintf '%04d', $args->{sm}
        if defined $args->{sm} and $args->{sm} =~ /^\d+$/;

    return $class;
};

sub validate {
    my ($self) = @_;

    $self->SUPER::validate;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and not $self->{sm} =~ /^\d{4}$/;

    return $self;
};

1;
