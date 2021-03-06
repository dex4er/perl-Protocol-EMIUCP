package Protocol::EMIUCP::Message::Role::R_5x_A;

use Mouse::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::R_A);

use Protocol::EMIUCP::Message::Field;

with_field [qw( mvp )];

use constant list_data_field_names => [qw( mvp sm )];

1;
