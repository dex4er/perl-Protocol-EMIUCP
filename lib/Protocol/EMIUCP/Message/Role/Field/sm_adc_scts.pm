package Protocol::EMIUCP::Message::Role::Field::sm_adc_scts;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Protocol::EMIUCP::Message::Role);

use Carp qw(confess);
use Scalar::Util qw(blessed);
use Protocol::EMIUCP::Util qw(has);

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

has 'sm';

sub build_args_sm_adc_scts {
    my ($class, $args) = @_;

    $args->{sm_scts} = DateTime::Format::EMIUCP::SCTS->format_datetime($args->{sm_scts})
        if blessed $args->{sm_scts} and $args->{sm_scts}->isa('DateTime');

    $args->{sm} = sprintf '%s:%s', $args->{sm_adc}, $args->{sm_scts}
        if defined $args->{sm_adc} and defined $args->{sm_scts};

    return $class;
};

sub validate_sm_adc_scts {
    my ($self) = @_;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and not $self->{sm}  =~ /^\d{1,16}:\d{12}$/;

    return $self;
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

sub sm_scts_datetime {
    my ($self) = @_;

    return unless my $scts = $self->sm_scts;
    return DateTime::Format::EMIUCP::SCTS->parse_datetime($scts);
};

sub build_hashref_sm_adc_scts {
    my ($self, $hashref) = @_;
    if (defined $hashref->{sm}) {
        $hashref->{sm_adc}  = $self->sm_adc;
        $hashref->{sm_scts} = $self->sm_scts;

        $hashref->{sm_scts_datetime} = $self->sm_scts_datetime
            if HAVE_DATETIME;
    };
    return $self;
};

1;
