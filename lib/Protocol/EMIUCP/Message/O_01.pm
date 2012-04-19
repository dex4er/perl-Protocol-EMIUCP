package Protocol::EMIUCP::Message::O_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::Field::mt
    Protocol::EMIUCP::Message::Role::Field::amsg
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::O
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has from_hex_to_utf8 from_utf8_to_hex );

has [qw( adc oadc ac nmsg amsg )];

use constant list_valid_mt_values => [ qw( 2 3 ) ];

sub build_args {
    my ($class, $args) = @_;

    $class->$_($args) foreach map { "build_${_}_args" } qw( o ot_01 mt amsg );

    return $class;
};

sub validate {
    my ($self) = @_;

    $self->$_ foreach map { "validate_$_" } qw( o ot_01 mt amsg );

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
    confess "Attribute (nmsg) is invalid"
        if defined $self->{nmsg} and not $self->{nmsg} =~ /^\d{1,160}$/;

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
    return [ qw( adc oadc ac mt ), $MT_To_Field[$mt] ];
};

sub build_hashref {
    my ($self, $hashref) = @_;

    $self->$_($hashref) foreach map { "build_${_}_hashref" } qw( mt amsg );

    return $self;
};

1;
