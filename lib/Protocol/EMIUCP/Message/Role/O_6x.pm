package Protocol::EMIUCP::Message::Role::O_6x;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;
use Protocol::EMIUCP::Message::Field;

with qw(
    Protocol::EMIUCP::Message::Role::O
    Protocol::EMIUCP::Message::Role::OT_6x
);

has [qw( ladc lton lnpi res1 )];
has_field [qw( oadc_num oton onpi styp pwd npwd vers opid )];

use constant list_data_field_names => [qw( oadc oton onpi styp pwd npwd vers ladc lton lnpi opid res1 )];

1;
