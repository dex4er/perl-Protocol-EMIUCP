package Protocol::EMIUCP::Message::Role::sm;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Util qw( decode_hex encode_hex );
use Protocol::EMIUCP::Field;
use Protocol::EMIUCP::Field::sm;

has_field 'sm';

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{sm_adc}) {
        $args{sm} = Protocol::EMIUCP::Field::sm->new(
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
