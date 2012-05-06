package Protocol::EMIUCP::Message::Role::Field::lrad;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'lrad' => (isa => 'EMIUCP_Num16');

1;
