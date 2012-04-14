package Protocol::EMIUCP::Message::R_01_N;

use 5.006;

our $VERSION = '0.01';


use Moose;
use Moose::Util::TypeConstraints;

with 'Protocol::EMIUCP::Message::Role::R';
with 'Protocol::EMIUCP::Message::Role::OT_01';

use Protocol::EMIUCP::Field;

has_field  'nack';
with_field 'ec';
with_field  sm     => (role => 'sm_scts');

sub list_data_field_names {
    return qw( nack ec sm );
};

sub list_ec_codes {
    return qw( 01 02 03 04 05 06 07 08 24 23 26 );
};

__PACKAGE__->meta->make_immutable();

1;
