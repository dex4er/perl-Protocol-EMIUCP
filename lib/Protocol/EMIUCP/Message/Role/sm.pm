package Protocol::EMIUCP::Message::Role::sm;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw(decode_hex encode_hex);

has sm => (is => 'ro', isa => 'Protocol::EMIUCP::Field::sm', coerce => 1, predicate => 'has_sm');

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{sm_adc} and defined $args{sm_scts}) {
        $args{sm} = Protocol::EMIUCP::Field::sm->new(
            adc  => $args{sm_adc},
            scts => $args{sm_scts},
        );
    };
    return $class->$orig(%args);
};

sub sm_adc { return (shift)->sm->adc };

sub sm_scts { return (shift)->sm->scts };

sub sm_as_string { return (shift)->sm->as_string };

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{sm}) {
        $hashref->{sm} = $self->sm_as_string;
        $hashref->{sm_adc} = $self->sm_adc;
        $hashref->{sm_scts} = $self->sm_scts;
    };
    return $hashref;
};


1;
