package Protocol::EMIUCP::Message::Role::R_N;

use Mouse::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::R);

use Protocol::EMIUCP::Message::Field;

with_field 'nack';

1;
