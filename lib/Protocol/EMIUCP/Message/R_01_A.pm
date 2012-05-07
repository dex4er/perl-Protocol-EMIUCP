package Protocol::EMIUCP::Message::R_01_A;

use Moose;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::R_A
);

with_field 'sm_adc_scts';

use constant list_data_field_names => [qw( ack sm )];

__PACKAGE__->meta->make_immutable();

1;
