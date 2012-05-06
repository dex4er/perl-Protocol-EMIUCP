package Protocol::EMIUCP::Message::Role::Field::hplmn;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'hplmn' => (isa => 'EMIUCP_16');

1;
