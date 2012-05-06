package Protocol::EMIUCP::Message::R_31_A;

use Mouse;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::R_A
);

with_field 'sm_num4';

use constant list_data_field_names => [qw( ack sm )];

__PACKAGE__->meta->make_immutable();

1;
