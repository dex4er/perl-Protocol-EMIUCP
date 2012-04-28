package Protocol::EMIUCP::Message::R_52_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;
use Protocol::EMIUCP::Message::Field;

has_field 'sm_maybe_adc_scts';

with qw(
    Protocol::EMIUCP::Message::Role::OT_52
    Protocol::EMIUCP::Message::Role::R_5x_A
);
extends qw(Protocol::EMIUCP::Message::Object);

1;
