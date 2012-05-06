package Protocol::EMIUCP::Message::Role::Field::mms;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'mms' => (isa => 'EMIUCP_Num1');

1;
