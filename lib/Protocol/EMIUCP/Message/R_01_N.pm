package Protocol::EMIUCP::Message::R_01_N;

use Moose;
use MooseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_N
);

use Moose::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['01']), default => '01');

use Protocol::EMIUCP::Message::Field;

with_field [qw( ec sm_adc_scts )];

has '+ec'  => (isa => enum([qw( 01 02 03 04 05 06 07 08 24 23 26 )]));

use constant list_data_field_names => [qw( nack ec sm )];

__PACKAGE__->meta->make_immutable();

1;
