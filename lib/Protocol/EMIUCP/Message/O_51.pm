package Protocol::EMIUCP::Message::O_51;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Base::O_50
    Protocol::EMIUCP::Message::Base::OT_51
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

sub build_args {
    my ($class, $args) = @_;

    $args->{oadc} = from_utf8_to_7bit_hex $args->{oadc_utf8}
        if defined $args->{oadc_utf8};

    return $class->build_ot_51_args($args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (adc) is invalid"
        unless $self->{adc}  =~ /^\d{1,16}$/;

    confess "Attribute (oadc) is required"
        unless defined $self->{oadc};
    confess "Attribute (oadc) is invalid"
        unless $self->{oadc}  =~ /^\d{1,16}|[\dA-F]{2,22}$/;

    return $self->SUPER::validate
                ->validate_ot_51;
};

use constant list_valid_npid_codes => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

use constant list_valid_lpid_codes => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

sub oadc_utf8 {
    my ($self) = @_;
    return from_7bit_hex_to_utf8 $self->{oadc};
};

sub build_hashref {
    my ($self, $hashref) = @_;
    $hashref->{oadc_utf8} = $self->oadc_utf8 if defined $hashref->{oadc}; # TODO and $hashref->{otoa} eq '5039'
    return $self;
};

1;
