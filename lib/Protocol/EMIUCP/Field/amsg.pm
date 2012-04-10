package Protocol::EMIUCP::Field::amsg;

use 5.008;

our $VERSION = '0.01';


use Moose;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw( decode_hex encode_hex );

has value => (is => 'ro', isa => 'Hex640', required => 1);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    $args{value} = encode_hex($args{utf8}) if defined $args{utf8};
    return $class->$orig(%args);
};

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub utf8 {
    my ($self) = @_;
    return decode_hex($self->value);
};


__PACKAGE__->meta->make_immutable();

1;
