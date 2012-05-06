package Protocol::EMIUCP::Message::Role::Field::cpg;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'cpg' => (isa => 'EMIUCP_Num1');

1;
