package Protocol::EMIUCP::Message::Role::R_50_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO::Role;

with qw(
    Protocol::EMIUCP::Message::Role::R_A
    Protocol::EMIUCP::Message::Role::OT_50
);

has_field [qw( mvp sm_adc_scts )];

use constant list_data_field_names => [ qw( ack mvp sm ) ];

1;
