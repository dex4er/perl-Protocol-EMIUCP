package Protocol::EMIUCP::Message::R_60_A;

use Moose;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_60
    Protocol::EMIUCP::Message::Role::R_6x_A
);

use Protocol::EMIUCP::Message::Field;

with_field 'sm_str';

__PACKAGE__->meta->make_immutable();

1;
