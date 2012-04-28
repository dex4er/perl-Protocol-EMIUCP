package Protocol::EMIUCP::Message::O_53;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_53
    Protocol::EMIUCP::Message::Role::O_50
);
extends qw(Protocol::EMIUCP::Message::Object);

use constant list_required_field_names => [qw( adc oadc scts dst rsn dscts mt )];
use constant list_empty_field_names => [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid pr dcs mcls rpl cpg rply
    otoa xser res4 res5
)];

1;
