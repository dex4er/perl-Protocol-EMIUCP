package Protocol::EMIUCP::Message::R_31_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::R_A
);
extends qw(Protocol::EMIUCP::Message::Object);

has_field 'sm_num4';

use constant list_data_field_names => [qw( ack sm )];

1;
