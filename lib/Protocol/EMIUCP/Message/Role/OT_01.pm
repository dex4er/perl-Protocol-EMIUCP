package Protocol::EMIUCP::Message::Role::OT_01;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;

has_field ot => (
    default       => '01',
    documentation => 'Call Input Operation',
);

before BUILD => sub {
    my ($self) = @_;
    confess 'OT != "01"' if $self->ot != 1;
};


1;
