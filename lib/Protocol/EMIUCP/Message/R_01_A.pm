package Protocol::EMIUCP::Message::R_01_A;

use 5.008;

our $VERSION = '0.01';


use Moose;
with 'Protocol::EMIUCP::Message::Role::R_01';

use Protocol::EMIUCP::Types;

has ack      => (is => 'ro', isa => 'ACK', coerce => 1, default => 'A');

sub list_data_field_names {
    return qw( ack sm )
};


1;
