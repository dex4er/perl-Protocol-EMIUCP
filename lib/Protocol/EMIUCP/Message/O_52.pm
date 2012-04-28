package Protocol::EMIUCP::Message::O_52;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_52
    Protocol::EMIUCP::Message::Role::O_50
);
extends qw(Protocol::EMIUCP::Message::Object);

use constant list_required_field_names => [qw( adc oadc scts )];
use constant list_empty_field_names => [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp dst rsn dscts pr cpg rply otoa
    res4 res5
)];

1;
