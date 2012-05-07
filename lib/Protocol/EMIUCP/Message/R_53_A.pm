package Protocol::EMIUCP::Message::R_53_A;

use Moose;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_53
    Protocol::EMIUCP::Message::Role::R_5x_A
);

use Protocol::EMIUCP::Message::Field;

with_field 'sm_maybe_adc_scts';

__PACKAGE__->meta->make_immutable();

1;
