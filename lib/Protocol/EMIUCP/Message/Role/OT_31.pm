package Protocol::EMIUCP::Message::Role::OT_31;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;

has_field ot => (
    default       => '31',
    documentation => 'MT Alert Operation',
);

before BUILD => sub {
    my ($self) = @_;
    confess 'OT != 31' if $self->ot != 31;
};


1;
