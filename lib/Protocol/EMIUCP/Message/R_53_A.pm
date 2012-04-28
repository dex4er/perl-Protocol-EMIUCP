package Protocol::EMIUCP::Message::R_53_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;
use Protocol::EMIUCP::Message::Field;

has_field 'sm_maybe_adc_scts';

with qw(
    Protocol::EMIUCP::Message::Role::OT_53
    Protocol::EMIUCP::Message::Role::R_50_A
);
extends qw(Protocol::EMIUCP::Message::Object);

1;
