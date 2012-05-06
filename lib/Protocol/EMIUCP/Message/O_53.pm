package Protocol::EMIUCP::Message::O_53;

use Mouse;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_53
    Protocol::EMIUCP::Message::Role::O_5x
);

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc scts dst rsn dscts mt )];
empty_field [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid pr dcs mcls rpl cpg rply
    otoa xser res4 res5
)];

__PACKAGE__->meta->make_immutable();

1;
