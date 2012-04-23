package Protocol::EMIUCP::Message::O_51;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_51
    Protocol::EMIUCP::Message::Role::O_50
);
extends qw(Protocol::EMIUCP::Message::Object);

use constant list_valid_npid_values => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

use constant list_valid_lpid_values => [ qw( 0100 0122 0131 0138 0139 0339 0439 0539 ) ];

use constant list_required_field_names => [ qw( adc oadc mt ) ];
use constant list_conflicting_field_names => [ qw( scts dst rsn dscts dcs cpg rply hplmn res4 res5 ) ];

use Carp qw(confess);

1;
