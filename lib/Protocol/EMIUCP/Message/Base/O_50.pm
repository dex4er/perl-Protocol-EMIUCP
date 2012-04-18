package Protocol::EMIUCP::Message::Base::O_50;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Base::O);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

__PACKAGE__->make_accessors( [qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd )] );

sub build_args {
    my ($class, $args) = @_;

    $args->{oadc} = from_utf8_to_7bit_hex $args->{oadc_utf8}
        if defined $args->{oadc_utf8};

    return $class;
};

sub validate {
    my ($self) = @_;

    confess "Attribute (adc) is invalid"
        unless $self->{adc}  =~ /^\d{1,16}$/;
    confess "Attribute (oadc) is invalid"
        unless $self->{oadc}  =~ /^\d{1,16}|[\dA-F]{2,22}$/;

    return $self->SUPER::validate;
};

use constant list_data_field_names => [ qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd ) ];

sub build_hashref {
    my ($self, $hashref) = @_;
    $hashref->{oadc_utf8} = $self->oadc_utf8 if defined $hashref->{oadc}; # TODO and $hashref->{otoa} eq '5039'
    return $self;
};

1;
