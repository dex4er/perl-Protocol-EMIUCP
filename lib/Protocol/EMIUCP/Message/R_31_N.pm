package Protocol::EMIUCP::Message::R_31_N;

use 5.008;

our $VERSION = '0.01';


use Moose;
with 'Protocol::EMIUCP::Message::Role::R';
with 'Protocol::EMIUCP::Message::Role::OT_31';

use Protocol::EMIUCP::Field;

with_field [qw( nack ec )];
with_field sm => 'sm_str';

sub list_data_field_names {
    return qw( nack ec sm );
};

sub list_ec_codes {
    return qw( 01 02 04 05 06 07 08 24 26 );
};

__PACKAGE__->meta->make_immutable();

1;
