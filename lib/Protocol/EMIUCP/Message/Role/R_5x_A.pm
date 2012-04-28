package Protocol::EMIUCP::Message::Role::R_5x_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;
use Protocol::EMIUCP::Message::Field;

with qw(
    Protocol::EMIUCP::Message::Role::R_A
    Protocol::EMIUCP::Message::Role::OT_5x
);

has_field [qw( mvp )];

use constant list_data_field_names => [qw( ack mvp sm )];

1;
