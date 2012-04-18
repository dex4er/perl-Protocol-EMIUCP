package Protocol::EMIUCP::Message::Base::O_50;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::O
    Protocol::EMIUCP::Message::Field::nt
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

__PACKAGE__->make_accessors( [qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd )] );

sub build_args {
    my ($class, $args) = @_;

    $args->{oadc} = from_utf8_to_7bit_hex $args->{oadc_utf8}
        if defined $args->{oadc_utf8};
    $args->{nrq}  = 0
        if exists $args->{nrq} and not $args->{nrq};

    return $class
        ->build_nt_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (adc) is invalid"
        if defined $self->{adc}  and not $self->{adc}  =~ /^\d{1,16}$/;
    confess "Attribute (oadc) is invalid"
        if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}|[\dA-F]{2,22}$/;
    confess "Attribute (ac) is invalid"
        if defined $self->{ac}   and not $self->{ac}   =~ /^\d{4,16}$/;
    confess "Attribute (nrq) is invalid"
        if defined $self->{nrq}  and not $self->{nrq}  =~ /^[01]$/;
    confess "Attribute (nadc) is invalid"
        if defined $self->{nadc} and not $self->{nadc} =~ /^\d{1,16}$/;

    return $self
        ->SUPER::validate
        ->validate_nt;
};

use constant list_data_field_names => [ qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd ) ];

sub oadc_utf8 {
    my ($self) = @_;
    return from_7bit_hex_to_utf8 $self->{oadc};
};

sub build_hashref {
    my ($self, $hashref) = @_;
    $hashref->{oadc_utf8} = $self->oadc_utf8 if defined $hashref->{oadc}; # TODO and $hashref->{otoa} eq '5039'
    return $self
        ->build_nt_hashref($hashref);
};

1;
