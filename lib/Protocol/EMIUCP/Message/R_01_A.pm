package Protocol::EMIUCP::Message::R_01_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::Field::sm_adc_scts
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::R_A
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);

use constant list_data_field_names => [ qw( ack sm ) ];

sub build_args {
    my ($class, $args) = @_;
    return $class
        ->build_ot_01_args($args)
        ->build_sm_args($args);
};

sub validate {
    my ($self) = @_;
    return $self
        ->validate_r_a
        ->validate_ot_01
        ->validate_sm;
};

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self
        ->build_sm_hashref($hashref);
};

1;
