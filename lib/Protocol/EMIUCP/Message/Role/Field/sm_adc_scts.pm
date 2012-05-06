package Protocol::EMIUCP::Message::Role::Field::sm_adc_scts;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

subtype 'EMIUCP_SM_AdC_SCTS' => as 'Str' => where { /^\d{1,16}:\d{12}$/ };

use Protocol::EMIUCP::Message::Field;

has_field 'sm' => (isa => 'EMIUCP_SM_AdC_SCTS');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    $args{sm_scts} = DateTime::Format::EMIUCP::SCTS->format_datetime($args{sm_scts})
        if blessed $args{sm_scts} and $args{sm_scts}->isa('DateTime');

    $args{sm} = sprintf '%s:%s', delete $args{sm_adc}, delete $args{sm_scts}
        if defined $args{sm_adc} and defined $args{sm_scts};

    return $class->$orig(%args);
};

sub sm_adc {
    my ($self) = @_;

    return unless defined $self->{sm} and $self->{sm} =~ /^(\d{1,16}):\d{12}$/;

    return $1;
};

sub sm_scts {
    my ($self) = @_;

    return unless defined $self->{sm} and $self->{sm} =~ /^\d{1,16}:(\d{12})$/;

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
        $hashref->{sm_adc}  = $self->sm_adc;
        $hashref->{sm_scts} = $self->sm_scts;
        $hashref->{sm_scts_datetime} = $self->sm_scts_datetime->datetime
            if HAVE_DATETIME;
    };
};

1;
