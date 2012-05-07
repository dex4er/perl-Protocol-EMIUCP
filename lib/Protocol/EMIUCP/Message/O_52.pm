package Protocol::EMIUCP::Message::O_52;

use Moose;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_52
    Protocol::EMIUCP::Message::Role::O_5x
);

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc scts )];
empty_field [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp dst rsn dscts pr cpg rply otoa
    res4 res5
)];

__PACKAGE__->meta->make_immutable();

1;
