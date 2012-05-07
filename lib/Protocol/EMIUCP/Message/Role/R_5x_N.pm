package Protocol::EMIUCP::Message::Role::R_5x_N;

use 5.006;

use Moose::Role;

our $VERSION = '0.01';

with qw(Protocol::EMIUCP::Message::Role::R_N);

use Protocol::EMIUCP::Message::Field;

with_field [qw( ec sm_str )];

use constant list_data_field_names => [qw( nack ec sm )];

1;
