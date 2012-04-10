package Protocol::EMIUCP::Message::R_01_A;

use 5.008;

our $VERSION = '0.01';


use Moose;
with 'Protocol::EMIUCP::Message::Role::R_01';
with 'Protocol::EMIUCP::Message::Role::ack';

sub list_data_field_names {
    return qw( ack sm )
};


__PACKAGE__->meta->make_immutable();

1;
