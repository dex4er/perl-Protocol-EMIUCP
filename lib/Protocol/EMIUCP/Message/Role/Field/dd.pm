package Protocol::EMIUCP::Message::Role::Field::dd;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'dd' => (isa => 'EMIUCP_Bool');

1;
