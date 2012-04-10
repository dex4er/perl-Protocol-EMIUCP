package Protocol::EMIUCP::Field::scts;

use 5.008;

our $VERSION = '0.01';


use Moose;

use overload (
    q{""}    => 'as_string',
    fallback => 1
);

use Protocol::EMIUCP::Types;
use DateTime::Format::EMIUCP;

has value => (is => 'ro', isa => 'SCTS', coerce => 1, required => 1);

sub as_string {
    my ($self) = @_;
    return $self->value;
};

sub as_datetime {
    my ($self) = @_;
    return DateTime::Format::EMIUCP->parse_datetime($self->value);
};


__PACKAGE__->meta->make_immutable();

1;
