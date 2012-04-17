package Protocol::EMIUCP::Message::R_31_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::R_N
    Protocol::EMIUCP::Message::Base::OT_31
    Protocol::EMIUCP::Message::Field::ec
);

use Carp qw(confess);

__PACKAGE__->make_accessors( [qw( ec sm )] );

sub build_args {
    my ($class, $args) = @_;
    return $class->build_ot_31_args($args)
                 ->build_ec_args($args);
};

sub validate {
    my ($self) = @_;
    return $self->validate_ot_31
                ->validate_ec;
};

use constant list_data_field_names => [ qw( nack ec sm ) ];

use constant list_valid_ec_codes => [ qw( 01 02 04 05 06 07 08 24 26 ) ];

sub build_hashref {
    my ($self, $hashref) = @_;
    return $self->build_ec_hashref($hashref);
};

1;
