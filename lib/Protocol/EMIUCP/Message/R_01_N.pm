package Protocol::EMIUCP::Message::R_01_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Protocol::EMIUCP::OO;

with qw(
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::R_N
);
extends qw(Protocol::EMIUCP::Message::Object);

has_field [qw( ec sm_adc_scts )];

use Carp qw(confess);

use constant list_data_field_names => [ qw( nack ec sm ) ];

use constant list_valid_ec_values => [ qw( 01 02 03 04 05 06 07 08 24 23 26 ) ];

1;
