package Protocol::EMIUCP::Field::oadc;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Util qw( decode_hex encode_hex );
use Protocol::EMIUCP::Types::oadc;
use Protocol::EMIUCP::Field;

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{oadc_utf8}) {
        $args{oadc} = Protocol::EMIUCP::Types::oadc->new(
            utf8 => $args{oadc_utf8},
        );
    };
    return $class->$orig(%args);
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{oadc}) {
        $hashref->{oadc}             = $self->oadc_string;
        $hashref->{oadc_is_alphanum} = $self->oadc_is_alphanum;
        $hashref->{oadc_utf8}        = $self->oadc_utf8 if $self->oadc_is_alphanum;
    };
    return $hashref;
};


1;
