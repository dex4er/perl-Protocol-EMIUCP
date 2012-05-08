package Protocol::EMIUCP::Message::Role::R_N;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

with_field 'nack';

1;
