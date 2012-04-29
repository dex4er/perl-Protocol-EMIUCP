package Protocol::EMIUCP::Message::R_52_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_52
    Protocol::EMIUCP::Message::Role::R_5x_N
);

1;
