package Protocol::EMIUCP::Message::Role::Field::sm_maybe_adc_scts;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(Protocol::EMIUCP::Message::Role);

has 'sm';

use Carp qw(confess);
use Scalar::Util qw(blessed);

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

sub _build_args_sm_maybe_adc_scts {
    my ($class, $args) = @_;

    if (defined $args->{sm_scts}) {
        $args->{sm_scts} = DateTime::Format::EMIUCP::SCTS->format_datetime($args->{sm_scts})
            if blessed $args->{sm_scts} and $args->{sm_scts}->isa('DateTime');

        $args->{sm} = defined $args->{sm_adc}
                    ? sprintf '%s:%s', $args->{sm_adc}, $args->{sm_scts}
                    : $args->{sm_scts};
    };

    return $class;
};

sub _validate_sm_maybe_adc_scts {
    my ($self) = @_;

    confess "Attribute (sm) is invalid"
        if defined $self->{sm} and $self->{sm} =~ m{/};

    return $self;
};

sub sm_adc {
    my ($self) = @_;

    return unless defined $self->{sm} and $self->{sm} =~ / ^ ( \d{1,16} ) : \d{12} $ /x;

    return $1;
};

sub sm_scts {
    my ($self) = @_;

    return unless defined $self->{sm} and $self->{sm} =~ / ^ (?: \d{1,16} : )? ( \d{12} ) $ /x;

    return $1;
};

sub sm_scts_datetime {
    my ($self) = @_;

    return unless my $scts = $self->sm_scts;
    return DateTime::Format::EMIUCP::SCTS->parse_datetime($scts);
};

sub _build_hashref_sm_maybe_adc_scts {
    my ($self, $hashref) = @_;
    if (defined $hashref->{sm}) {
        my $adc  = $self->sm_adc;
        my $scts = $self->sm_scts;
        $hashref->{sm_adc}  = $adc  if defined $adc;
        $hashref->{sm_scts} = $scts if defined $scts;
        $hashref->{sm_scts_datetime} = $self->sm_scts_datetime->datetime
            if HAVE_DATETIME and defined $scts;
    };
    return $self;
};

1;
