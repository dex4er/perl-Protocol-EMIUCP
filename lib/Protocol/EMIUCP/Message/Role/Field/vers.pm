package Protocol::EMIUCP::Message::Role::Field::vers;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'vers' => (isa => 'EMIUCP_Num04');

1;
