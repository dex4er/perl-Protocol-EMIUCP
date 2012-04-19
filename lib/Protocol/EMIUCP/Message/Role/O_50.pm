package Protocol::EMIUCP::Message::Role::O_50;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::Field::nt
    Protocol::EMIUCP::Message::Role::Field::npid
    Protocol::EMIUCP::Message::Role::Field::lpid
    Protocol::EMIUCP::Message::Role::Field::ddt
    Protocol::EMIUCP::Message::Role::Field::vp
    Protocol::EMIUCP::Message::Role::Field::scts
    Protocol::EMIUCP::Message::Role::Field::dst
    Protocol::EMIUCP::Message::Role::Field::dscts
    Protocol::EMIUCP::Message::Role::Field::mt
    Protocol::EMIUCP::Message::Role::OT_50
    Protocol::EMIUCP::Message::Role::O
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

has [qw( adc oadc ac nrq nadc lrq lrad lpid dd )];

use constant list_valid_rpid_values => [
    map { sprintf '%04d', $_ } 0..71, 95, 127, 192..255
];

use constant list_valid_rsn_values => [
    map { sprintf '%03d', $_ } 0..255
];

use constant list_valid_mt_values => [ qw( 2 3 4 )];

sub build_o_50_args {
    my ($class, $args) = @_;

    $class->$_($args) foreach map { "build_${_}_args" } qw( nt npid lpid ddt vp scts dst dscts mt );

    foreach my $name (qw( nrq lrq dd )) {
        $args->{$name}  = 0
            if exists $args->{$name} and not $args->{$name};
    };
    $args->{oadc} = from_utf8_to_7bit_hex $args->{oadc_utf8}
        if defined $args->{oadc_utf8};
    $args->{rpid} = sprintf '%04d', $args->{rpid}
        if defined $args->{rpid} and $args->{rpid} =~ /^\d+$/;
    $args->{rsn} = sprintf '%03d', $args->{rsn}
        if defined $args->{rsn} and $args->{rsn} =~ /^\d+$/;

    return $class;
};

sub validate_o_50 {
    my ($self) = @_;

    $self->$_ foreach map { "validate_$_" } qw( nt npid lpid ddt vp scts dst dscts mt );

    foreach my $name (qw( adc nadc lrad )) {
        confess "Attribute ($name) is invalid"
            if defined $self->{$name} and not $self->{$name}  =~ /^\d{1,16}$/;
    };
    foreach my $name (qw( nrq lrq dd )) {
        confess "Attribute ($name) is invalid"
            if defined $self->{$name} and not $self->{$name}  =~ /^[01]$/;
    };
    confess "Attribute (oadc) is invalid"
        if defined $self->{oadc} and not $self->{oadc} =~ /^\d{1,16}|[\dA-F]{2,22}$/;
    confess "Attribute (ac) is invalid"
        if defined $self->{ac}   and not $self->{ac}   =~ /^\d{4,16}$/;
    confess "Attribute (nadc) is invalid"
        if defined $self->{nadc} and not $self->{nadc} =~ /^\d{1,16}$/;
    confess "Attribute (rpid) is invalid"
        if defined $self->{rpid} and not grep { $_ eq $self->{rpid} } @{ $self->list_valid_rpid_values };
    confess "Attribute (rsn) is invalid"
        if defined $self->{rsn} and not grep { $_ eq $self->{rsn} } @{ $self->list_valid_rsn_values };
    confess "Attribute (nb) is invalid"
        if defined $self->{nb} and not $self->{nb} =~ /^\d{1,4}$/;

    return $self;
};

my @MT_To_Field;
@MT_To_Field[2, 3, 4] = qw( nmsg amsg tmsg );

sub list_data_field_names {
    my ($self, $fields) = @_;
    my $mt = ref $self ? $self->{mt}
           : (ref $fields || '') eq 'ARRAY' ? $fields->[22]
           : $fields->{mt};
    no warnings 'numeric';
    return [
        qw( adc oadc ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid scts dst rsn dscts mt nb ),
        $MT_To_Field[$mt || 3],
    ];
};

sub oadc_utf8 {
    my ($self) = @_;
    return from_7bit_hex_to_utf8 $self->{oadc};
};

sub build_hashref {
    my ($self, $hashref) = @_;

    $self->$_($hashref) foreach map { "build_${_}_hashref" } qw( nt npid lpid ddt vp scts dst dscts mt );

    $hashref->{oadc_utf8} = $self->oadc_utf8 if defined $hashref->{oadc}; # TODO and $hashref->{otoa} eq '5039'

    return $self;
};

1;
