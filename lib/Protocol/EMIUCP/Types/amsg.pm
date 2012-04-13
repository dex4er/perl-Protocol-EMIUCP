package Protocol::EMIUCP::Types::amsg;

use 5.008;

our $VERSION = '0.01';


use Moose;
use Moose::Util::TypeConstraints;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw( decode_hex encode_hex decode_utf8 encode_utf8 );

coerce 'Protocol::EMIUCP::Types::amsg'
    => from Any
    => via { Protocol::EMIUCP::Types::amsg->new( value => $_ ) };

has value => (is => 'ro', isa => 'EMIUCP_Hex640', required => 1);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    $args{value} = encode_hex decode_utf8 $args{utf8} if defined $args{utf8};
    return $class->$orig(%args);
};

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub utf8 {
    my ($self) = @_;
    return encode_utf8 decode_hex $self->value;
};


__PACKAGE__->meta->make_immutable();

1;
