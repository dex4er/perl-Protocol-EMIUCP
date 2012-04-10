package Protocol::EMIUCP::Field::ec;

use 5.008;

our $VERSION = '0.01';


use Moose;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use constant messages => {
    '01' => 'Checksum error',
    '02' => 'Syntax error',
    '03' => 'Operation not supported by system',
    '04' => 'Operation not allowed (at this point in time)',
    '05' => 'Call barring active',
    '06' => 'AdC invalid',
    '07' => 'Authentication failure',
    '08' => 'Legitimisation code for all calls, failure',
    '23' => 'Message type not supported by system',
    '24' => 'Message too long',
    '26' => 'Message type not valid for the pager type',
};

use Protocol::EMIUCP::Types;

has value => (is => 'ro', isa => 'Num2', coerce => 1, required => 1);

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub as_message {
    my ($self) = @_;
    return messages->{$self->value};
};


__PACKAGE__->meta->make_immutable();

1;
