package Protocol::EMIUCP::Message::amsg;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw(decode_hex encode_hex);

has amsg     => (is => 'ro', isa => 'Hex640', predicate => 'has_amsg');

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    $args{amsg} = encode_hex(delete $args{amsg_string})
        if defined $args{amsg_string};
    return $class->$orig(%args);
};

sub amsg_string {
    my ($self) = @_;
    return decode_hex($self->amsg);
};


1;
