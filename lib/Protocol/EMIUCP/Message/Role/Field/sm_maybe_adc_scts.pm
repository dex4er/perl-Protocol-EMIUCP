package Protocol::EMIUCP::Message::Role::Field::sm_maybe_adc_scts;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'sm' => (isa => 'EMIUCP_Str');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    if (defined $args{sm_scts}) {
        $args{sm_scts} = DateTime::Format::EMIUCP::SCTS->format_datetime($args{sm_scts})
            if blessed $args{sm_scts} and $args{sm_scts}->isa('DateTime');

        $args{sm} = defined $args{sm_adc}
                  ? sprintf '%s:%s', delete $args{sm_adc}, delete $args{sm_scts}
                  : delete $args{sm_scts};
    };

    return $class->$orig(%args);
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

after _make_hashref => sub {
    my ($self, $hashref) = @_;
    if (defined $hashref->{sm}) {
        my $adc  = $self->sm_adc;
        $hashref->{sm_adc}  = $adc  if defined $adc;

        my $scts = $self->sm_scts;
        $hashref->{sm_scts} = $scts if defined $scts;

        $hashref->{sm_scts_datetime} = $self->sm_scts_datetime->datetime
            if HAVE_DATETIME and defined $scts;
    };
    return $self;
};

1;
