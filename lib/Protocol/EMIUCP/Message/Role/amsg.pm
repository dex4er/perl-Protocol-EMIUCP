package Protocol::EMIUCP::Message::Role::amsg;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw(decode_hex encode_hex);
use Protocol::EMIUCP::Field::amsg;

has amsg => (
    is        => 'ro',
    isa       => 'Protocol::EMIUCP::Field::amsg',
    coerce    => 1,
    predicate => 'has_amsg',
    handles   => {
        amsg_as_string => 'value',
        amsg_utf8      => 'utf8',
    },
);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{amsg_utf8}) {
        $args{amsg} = Protocol::EMIUCP::Field::amsg->new(
            utf8 => $args{amsg_utf8},
        );
    };
    return $class->$orig(%args);
};

sub amsg_utf8 {
    my ($self) = @_;
    return decode_hex($self->amsg);
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if (defined $hashref->{amsg}) {
        $hashref->{amsg}      = $self->amsg->as_string;
        $hashref->{amsg_utf8} = $self->amsg->utf8;
    };
    return $hashref;
};


1;
