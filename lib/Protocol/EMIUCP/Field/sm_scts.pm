package Protocol::EMIUCP::Field::sm_scts;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types::sm_scts;
use Protocol::EMIUCP::Field;

has sm => (
    is        => 'ro',
    isa       => 'Protocol::EMIUCP::Types::sm_scts',
    coerce    => 1,
    predicate => 'has_sm',
    handles   => {
        sm_as_string => 'as_string',
        sm_adc       => 'adc',
        sm_scts      => 'scts',
    },
);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{sm_adc}) {
        $args{sm} = Protocol::EMIUCP::Types::sm_scts->new(
            adc  => $args{sm_adc},
            defined $args{sm_scts} ? (scts => $args{sm_scts}) : (),
        );
    };
    return $class->$orig(%args);
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{sm}) {
        $hashref->{sm}      = $self->sm_as_string;
        $hashref->{sm_adc}  = $self->sm_adc;
        $hashref->{sm_scts} = $self->sm_scts->as_string;
    };
    return $hashref;
};


1;
