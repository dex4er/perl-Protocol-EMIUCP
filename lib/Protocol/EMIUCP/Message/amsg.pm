package Protocol::EMIUCP::Message::amsg;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw(decode_hex encode_hex);

has amsg => (is => 'ro', isa => 'Protocol::EMIUCP::Field::amsg', coerce => 1, predicate => 'has_amsg');

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    $args{value} = encode_hex(delete $args{amsg_encode})
        if defined $args{amsg_encode};
    return $class->$orig(%args);
};

sub amsg_string {
    my ($self) = @_;
    return decode_hex($self->amsg);
};

around as_hashref => sub {
    my ($orig, $self) = @_;
    my $hashref = $self->$orig();
    if ($self->has_amsg) {
        $hashref->{amsg} = $self->amsg->as_string;
        $hashref->{amsg_encode} = $self->amsg->decode;
    };
    return $hashref;
};


1;
