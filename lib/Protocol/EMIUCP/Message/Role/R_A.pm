package Protocol::EMIUCP::Message::Role::R_A;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

with_field 'ack';

1;
