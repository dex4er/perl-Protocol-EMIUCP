package Protocol::EMIUCP::Field::ec;

use 5.008;

our $VERSION = '0.01';


use Moose;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;

has value => (is => 'ro', isa => 'Num2', coerce => 1, required => 1);

sub as_string {
    my ($self) = @_;
    return $self->value;
};


__PACKAGE__->meta->make_immutable();

1;
