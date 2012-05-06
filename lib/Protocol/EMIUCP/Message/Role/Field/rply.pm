package Protocol::EMIUCP::Message::Role::Field::rply;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'rply' => (isa => 'EMIUCP_Num1');

1;
