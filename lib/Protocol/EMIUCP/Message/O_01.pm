package Protocol::EMIUCP::Message::O_01;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

our @ISA;
use base qw(
    Protocol::EMIUCP::Message::Role::Field::mt
    Protocol::EMIUCP::Message::Role::Field::amsg
    Protocol::EMIUCP::Message::Role::Field::nmsg
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::O
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw( has from_hex_to_utf8 from_utf8_to_hex );

has [qw( adc oadc ac )];

use constant list_valid_mt_values => [ qw( 2 3 ) ];

sub build_args {
    my ($class, $args) = @_;

    $class->$_($args) foreach grep { $class->can($_) }
        map { /:(\w+)$/; sprintf 'build_%s_args', lc $1 } grep { /:Role:/ } @ISA;

    return $class;
};

sub validate {
    my ($self) = @_;

    $self->$_ foreach grep { $self->can($_) }
        map { /:(\w+)$/; sprintf 'validate_%s', lc $1 } grep { /:Role:/ } @ISA;

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
    return [ qw( adc oadc ac mt ), $MT_To_Field[$mt] ];
};

sub build_hashref {
    my ($self, $hashref) = @_;

    $self->$_($hashref) foreach grep { $self->can($_) }
        map { /:(\w+)$/; sprintf 'build_%s_hashref', lc $1 } grep { /:Role:/ } @ISA;

    return $self;
};

1;
