package Protocol::EMIUCP::Message::R_31_N;

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(
    Protocol::EMIUCP::Message::Role::Field::ec
    Protocol::EMIUCP::Message::Role::OT_31
    Protocol::EMIUCP::Message::Role::R_N
    Protocol::EMIUCP::Message::Object
);

use Carp qw(confess);
use Protocol::EMIUCP::Util qw(has);

has 'sm';

use constant list_data_field_names => [ qw( nack ec sm ) ];

use constant list_valid_ec_values => [ qw( 01 02 04 05 06 07 08 24 26 ) ];

1;
