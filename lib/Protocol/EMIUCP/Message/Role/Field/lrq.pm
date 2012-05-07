package Protocol::EMIUCP::Message::Role::Field::lrq;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'lrq' => (isa => 'EMIUCP_Bool', coerce => 1);

1;
