package Protocol::EMIUCP::Types::oadc;

use 5.006;

our $VERSION = '0.01';


use Moose;
use Moose::Util::TypeConstraints;

use constant::boolean;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use Protocol::EMIUCP::Util qw( decode_7bit_hex encode_7bit_hex decode_gsm encode_gsm decode_utf8 encode_utf8 );

coerce 'Protocol::EMIUCP::Types::oadc'
    => from EMIUCP_Num16
    => via { Protocol::EMIUCP::Types::oadc->new( value => $_ ) },
    => from EMIUCP_Hex22
    => via { Protocol::EMIUCP::Types::oadc->new( value => $_ ) },
    => from Str
    => via { Protocol::EMIUCP::Types::oadc->new( utf8 => $_ ) };

has value       => (is => 'ro', isa => 'EMIUCP_Num16 | EMIUCP_Hex22', required => 1);
has is_alphanum => (is => 'ro', isa => 'Bool', required => 1, default => FALSE);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;
    if (defined $args{utf8}) {
        $args{value}    = encode_7bit_hex encode_gsm decode_utf8 $args{utf8};
        $args{is_alphanum} = TRUE;
    };
    return $class->$orig(%args);
};

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub utf8 {
    my ($self) = @_;
    return encode_utf8 decode_gsm decode_7bit_hex $self->value;
};


__PACKAGE__->meta->make_immutable();

1;
