package Protocol::EMIUCP::Message::R_31_A;

use 5.006;

our $VERSION = '0.01';


use Moose;

with 'Protocol::EMIUCP::Message::Role::R';
with 'Protocol::EMIUCP::Message::Role::OT_31';

use Protocol::EMIUCP::Field;

has_field  'ack';
with_field  sm    => (role => 'sm_num4');

sub list_data_field_names {
    return qw( ack sm )
};


__PACKAGE__->meta->make_immutable();

1;
