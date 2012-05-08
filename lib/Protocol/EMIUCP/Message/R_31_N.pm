package Protocol::EMIUCP::Message::R_31_N;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_N
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['31']), default => '31');

use Protocol::EMIUCP::Message::Field;

with_field [qw( ec sm_str )];

use constant list_data_field_names => [qw( nack ec sm )];

use constant list_valid_ec_values => [qw( 01 02 04 05 06 07 08 24 26 )];

__PACKAGE__->meta->make_immutable();

1;
