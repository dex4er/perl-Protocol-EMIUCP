package Protocol::EMIUCP::Message::R_01_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::R_N
    Protocol::EMIUCP::Message::Field::ec
    Protocol::EMIUCP::Message::Field::sm_adc_scts
);

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( ec sm )] );

sub build_args {
    my ($class, $args) = @_;

    confess "Attribute (ot) is invalid, should be '01'"
        if defined $args->{ot} and $args->{ot} ne '01';

    return $class->build_ec_args($args)
                 ->build_sm_args($args);
};

sub validate {
    my ($self) = @_;
    return $self->validate_ec
                ->validate_sm;
};

sub list_data_field_names {
    return qw( nack ec sm );
};

sub list_ec_codes {
    return qw( 01 02 03 04 05 06 07 08 24 23 26 );
};

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self->build_ec_hashref($hashref)
                ->build_sm_hashref($hashref);
};

1;
