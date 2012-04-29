package Protocol::EMIUCP::Message::R_60_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;
use Protocol::EMIUCP::Message::Field;

has_field 'sm_str';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_60
    Protocol::EMIUCP::Message::Role::R_6x_N
);

1;
