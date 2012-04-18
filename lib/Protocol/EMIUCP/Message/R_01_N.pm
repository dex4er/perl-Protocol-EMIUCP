package Protocol::EMIUCP::Message::R_01_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::R_N
    Protocol::EMIUCP::Message::Base::OT_01
    Protocol::EMIUCP::Message::Field::ec
    Protocol::EMIUCP::Message::Field::sm_adc_scts
);

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( ec sm )] );

sub build_args {
    my ($class, $args) = @_;
    return $class
        ->build_ot_01_args($args)
        ->build_ec_args($args)
        ->build_sm_args($args);
};

sub validate {
    my ($self) = @_;
    return $self
        ->SUPER::validate
        ->validate_ot_01
        ->validate_ec
        ->validate_sm;
};

use constant list_data_field_names => [ qw( nack ec sm ) ];

use constant list_valid_ec_codes => [ qw( 01 02 03 04 05 06 07 08 24 23 26 ) ];

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self
        ->build_ec_hashref($hashref)
        ->build_sm_hashref($hashref);
};

1;
