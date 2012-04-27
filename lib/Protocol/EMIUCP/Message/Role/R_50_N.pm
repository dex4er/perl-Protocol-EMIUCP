package Protocol::EMIUCP::Message::Role::R_50_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;
use Protocol::EMIUCP::Message::Field;

with qw(
    Protocol::EMIUCP::Message::Role::R_N
    Protocol::EMIUCP::Message::Role::OT_50
);

has_field [qw( ec sm_str )];

use constant list_data_field_names => [qw( nack ec sm )];

1;
