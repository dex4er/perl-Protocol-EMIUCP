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

sub new {
    my ($class, %args) = @_;
    $class->build_ec_args(\%args)
          ->build_sm_args(\%args);
    return $class->SUPER::new(%args);
};

sub validate {
    my ($self) = @_;
    $self->validate_ec
         ->validate_sm;
    return $self;
};

sub list_data_field_names {
    return qw( nack ec sm );
};

sub list_ec_codes {
    return qw( 01 02 03 04 05 06 07 08 24 23 26 );
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = $self->SUPER::as_hashref;
    $self->build_ec_hashref($hashref)
         ->build_sm_hashref($hashref);
    return $hashref;
};

1;
