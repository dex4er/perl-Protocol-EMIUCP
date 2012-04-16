package Protocol::EMIUCP::Message::R_31_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw( Protocol::EMIUCP::Message::Base::R_A );

use Carp qw(confess);
use Scalar::Util qw(looks_like_number);

__PACKAGE__->make_accessors( [qw( sm )] );

sub build_args {
    my ($class, $args) = @_;

    $args->{ot} = '31' unless defined $args->{ot};

    $args->{sm} = sprintf '%04d', $args->{sm}
        if defined $args->{sm} and looks_like_number $args->{sm};

    return $class;
};

sub validate {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '31'"
        if defined $self->{ot} and $self->{ot} ne '31';
    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and not $self->{sm} =~ /^\d{4}$/;

    return $self;
};

sub list_data_field_names {
    return qw( ack sm )
};

1;
