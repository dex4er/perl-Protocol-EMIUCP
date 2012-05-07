package Protocol::EMIUCP::Message::Role::Field::nrq;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'nrq' => (isa => 'EMIUCP_Bool', coerce => 1);

1;
