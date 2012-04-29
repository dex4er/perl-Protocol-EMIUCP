package Protocol::EMIUCP::Message::O_60;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_60
    Protocol::EMIUCP::Message::Role::O_6x
);

use constant list_required_field_names => [qw( oadc styp pwd vers )];
use constant list_empty_field_names => [qw( ladc lton lnpi res1 )];

1;
