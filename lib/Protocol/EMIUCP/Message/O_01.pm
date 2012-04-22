package Protocol::EMIUCP::Message::O_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::O
);
extends qw(Protocol::EMIUCP::Message::Object);

has [qw( adc oadc ac )];
has_field [qw( mt amsg nmsg )];

use constant list_valid_mt_values => [ qw( 2 3 ) ];

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( from_hex_to_utf8 from_utf8_to_hex );

sub validate {
    my ($self) = @_;

    $self->SUPER::validate;

    confess "Attribute (adc) is required"
        unless defined $self->{adc};
    confess "Attribute (mt) is required"
        unless defined $self->{mt};

    confess "Attribute (adc) is invalid"
        unless $self->{adc}  =~ /^\d{1,16}$/;
    confess "Attribute (oadc) is invalid"
        if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}$/;
    confess "Attribute (ac) is invalid"
        if defined $self->{ac}   and not $self->{ac}   =~ /^\d{4,16}$/;

    return $self;
};

my @MT_To_Field;
@MT_To_Field[2, 3] = qw( nmsg amsg );

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[7]
           : $fields->{mt};
    no warnings 'numeric';
    return [ qw( adc oadc ac mt ), $MT_To_Field[$mt||0] || '-msg' ];
};

1;
