package Protocol::EMIUCP::Message::R_01_N;

use 5.008;

our $VERSION = '0.01';


use Moose;
with 'Protocol::EMIUCP::Message::Role::R_01';

use Protocol::EMIUCP::Types;

has nack     => (is => 'ro', isa => 'NACK', coerce => 1, default => 'N');
has ec       => (is => 'ro'); # TODO isa

sub list_data_field_names {
    return qw( nack ec sm );
};


1;
