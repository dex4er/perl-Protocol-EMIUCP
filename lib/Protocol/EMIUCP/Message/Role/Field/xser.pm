package Protocol::EMIUCP::Message::Role::Field::xser;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'xser' => (isa => 'EMIUCP_Hex400');

1;
