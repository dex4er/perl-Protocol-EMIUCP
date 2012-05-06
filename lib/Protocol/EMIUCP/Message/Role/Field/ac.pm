package Protocol::EMIUCP::Message::Role::Field::ac;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'ac' => (isa => 'EMIUCP_Num4_16');

1;
