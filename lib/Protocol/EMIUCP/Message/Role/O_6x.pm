package Protocol::EMIUCP::Message::Role::O_6x;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

with_field [qw( oadc_num oton onpi styp pwd npwd vers opid )];
has_field [qw( ladc lton lnpi res1 )];

use constant list_data_field_names => [qw( oadc oton onpi styp pwd npwd vers ladc lton lnpi opid res1 )];

1;
