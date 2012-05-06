package Protocol::EMIUCP::Message::R_31_N;

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::R_N
);

with_field [qw( ec sm_str )];

use constant list_data_field_names => [qw( nack ec sm )];

use constant list_valid_ec_values => [qw( 01 02 04 05 06 07 08 24 26 )];

__PACKAGE__->meta->make_immutable();

1;
