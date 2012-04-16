package Protocol::EMIUCP::Message::R_31_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::R_N
    Protocol::EMIUCP::Message::Field::ec
);

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( ec sm )] );

sub build_args {
    my ($class, $args) = @_;

    $args->{ot} = '31' unless defined $args->{ot};

    return $class->build_ec_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (ot) is invalid, should be '31'"
        if defined $self->{ot} and $self->{ot} ne '31';

    return $self->validate_ec;
};

sub list_data_field_names {
    return qw( nack ec sm );
};

sub list_ec_codes {
    return qw( 01 02 04 05 06 07 08 24 26 );
};

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self->build_ec_hashref($hashref);
};

1;
