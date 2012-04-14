package Protocol::EMIUCP::Field::amsg;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Util qw( decode_hex encode_hex );
use Protocol::EMIUCP::Types::amsg;
use Protocol::EMIUCP::Field;

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{amsg_utf8}) {
        $args{amsg} = Protocol::EMIUCP::Types::amsg->new(
            utf8 => $args{amsg_utf8},
        );
    };
    return $class->$orig(%args);
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{amsg}) {
        $hashref->{amsg}      = $self->amsg_string;
        $hashref->{amsg_utf8} = $self->amsg_utf8;
    };
    return $hashref;
};


1;
