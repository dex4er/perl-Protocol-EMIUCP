package Protocol::EMIUCP::Field::amsg;

use 5.008;

our $VERSION = '0.01';


use Moose;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw(decode_hex encode_hex);

has value => (is => 'ro', isa => 'Hex640', predicate => 'has_value');

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    $args{value} = encode_hex(delete $args{encode}) if defined $args{encode};
    return $class->$orig(%args);
};

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub decode {
    my ($self) = @_;
    return decode_hex($self->value);
};


1;
