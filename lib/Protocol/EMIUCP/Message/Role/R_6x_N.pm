package Protocol::EMIUCP::Message::Role::R_6x_N;

use Mouse::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::R_N);

use Protocol::EMIUCP::Message::Field;

with_field [qw( ec sm_str )];

use constant list_data_field_names => [qw( nack ec sm )];

1;
