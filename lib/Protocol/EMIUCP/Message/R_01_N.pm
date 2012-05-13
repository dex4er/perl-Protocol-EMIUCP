package Protocol::EMIUCP::Message::R_01_N;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_N
);

use Mouse::Util::TypeConstraints;

has '+o_r'  => (isa => enum(['R']),  required => 1, default => 'R');
has '+ot'   => (isa => enum(['01']), required => 1, default => '01');
has '+nack' => (                     required => 1, default => 'N');

use Protocol::EMIUCP::Message::Field;

with_field [qw( ec sm_adc_scts )];

has '+ec'  => (isa => enum([qw( 01 02 03 04 05 06 07 08 24 23 26 )]));

use constant list_data_field_names => [qw( nack ec sm )];

__PACKAGE__->meta->make_immutable();

1;
