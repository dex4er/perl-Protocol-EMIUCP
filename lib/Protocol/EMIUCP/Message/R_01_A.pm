package Protocol::EMIUCP::Message::R_01_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Protocol::EMIUCP::Message::R_A';

use Carp qw(confess);
use Scalar::Util qw(blessed);
eval { require DateTime::Format::EMIUCP::SCTS };

__PACKAGE__->make_accessors( [qw( sm )] );

sub new {
    my ($class, %args) = @_;

    $args{sm_scts} = DateTime::Format::EMIUCP::SCTS->format_datetime($args{sm_scts})
        if blessed $args{sm_scts} and $args{sm_scts}->isa('DateTime');

    $args{sm} = sprintf '%s:%s', $args{sm_adc}, $args{sm_scts}
        if defined $args{sm_adc} and defined $args{sm_scts};

    return $class->SUPER::new(%args);
};

sub validate {
    my ($self) = @_;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm}  and not $self->{sm}  =~ /^\d{1,16}:\d{12}$/;

    return $self;
};

sub list_data_field_names {
    return qw( ack sm );
};

sub sm_adc {
    my ($self) = @_;

    return unless defined $self->{sm} and $self->{sm}  =~ / ^ ( \d{1,16} ) : \d{12} $ /x;

    return $1;
};

sub sm_scts {
    my ($self) = @_;

    return unless defined $self->{sm} and $self->{sm}  =~ / ^ \d{1,16} : ( \d{12} ) $ /x;

    return $1;
};

sub sm_scts_as_datetime {
    my ($self) = @_;

    return unless my $scts = $self->sm_scts;
    return DateTime::Format::EMIUCP::SCTS->parse_datetime($scts);
};

sub as_hashref {
    my ($self) = @_;
    my $hashref = $self->SUPER::as_hashref;
    if (defined $hashref->{sm}) {
        $hashref->{sm_adc}  = $self->sm_adc;
        $hashref->{sm_scts} = $self->sm_scts;
    };
    return $hashref;
};

1;
