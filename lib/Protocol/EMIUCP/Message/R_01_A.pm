package Protocol::EMIUCP::Message::R_01_A;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::OT_01
    Protocol::EMIUCP::Message::Role::R_A
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(with_field);

with_field 'sm_adc_scts';

use constant list_data_field_names => [ qw( ack sm ) ];

1;
