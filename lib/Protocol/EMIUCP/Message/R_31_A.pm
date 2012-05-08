package Protocol::EMIUCP::Message::R_31_A;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_A
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['31']), default => '31');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_num4';

use constant list_data_field_names => [qw( ack sm )];

__PACKAGE__->meta->make_immutable();

1;
