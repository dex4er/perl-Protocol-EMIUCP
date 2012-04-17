package Protocol::EMIUCP::Message::R_01_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::R_A
    Protocol::EMIUCP::Message::Base::OT_01
    Protocol::EMIUCP::Message::Field::sm_adc_scts
);

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( sm )] );

sub build_args {
    my ($class, $args) = @_;
    return $class->build_ot_01_args($args)
                 ->build_sm_args($args);
};

sub validate {
    my ($self) = @_;
    return $self->validate_ot_01
                ->validate_sm;
};

sub list_data_field_names {
    return qw( ack sm );
};

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self->build_sm_hashref($hashref);
};

1;
