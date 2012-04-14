package Protocol::EMIUCP::Message::R_01_A;

use 5.006;

our $VERSION = '0.01';


use Moose;

with 'Protocol::EMIUCP::Message::Role::R';
with 'Protocol::EMIUCP::Message::Role::OT_01';

use Protocol::EMIUCP::Field;

has_field  'ack';
with_field  sm    => (role => 'sm_scts');

sub list_data_field_names {
    return qw( ack sm )
};


__PACKAGE__->meta->make_immutable();

1;
