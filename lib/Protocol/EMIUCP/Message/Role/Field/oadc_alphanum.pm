package Protocol::EMIUCP::Message::Role::Field::oadc_alphanum;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'oadc';

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

use Protocol::EMIUCP::Message::Role::Field::otoa;
BEGIN { Protocol::EMIUCP::Message::Role::Field::otoa->import_otoa };

sub build_args_oadc_alphanum {
    my ($class, $args) = @_;

    $args->{oadc} = from_utf8_to_7bit_hex $args->{oadc_utf8}
        if defined $args->{oadc_utf8};

    return $class;
};

sub validate_oadc_alphanum {
    my ($self) = @_;

    if (defined $self->{otoa} and $self->{otoa} eq OTOA_ALPHANUMERIC) {
        confess "Attribute (oadc) is invalid"
            if defined $self->{oadc} and not $self->{oadc} =~ /^[\dA-F]{2,22}$/;
    }
    else {
        confess "Attribute (oadc) is invalid"
            if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}$/;
    };

    return $self;
};

sub oadc_utf8 {
    my ($self) = @_;
    return from_7bit_hex_to_utf8 $self->{oadc};
};

sub build_hashref_oadc_alphanum {
    my ($self, $hashref) = @_;
    if (defined $self->{otoa} and $self->{otoa} eq OTOA_ALPHANUMERIC) {
        $hashref->{oadc_utf8} = $self->oadc_utf8 if defined $hashref->{oadc};
    };
    return $self;
};

1;
