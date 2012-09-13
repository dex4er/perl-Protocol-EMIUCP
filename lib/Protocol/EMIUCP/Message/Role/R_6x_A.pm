package Protocol::EMIUCP::Message::Role::R_6x_A;

use Mouse::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::R_A);

use constant list_data_field_names => [qw( sm )];

1;
