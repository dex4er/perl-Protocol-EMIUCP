package Protocol::EMIUCP::Message::Role::Field::sm_str;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'sm' => (isa => 'EMIUCP_Str');

1;
