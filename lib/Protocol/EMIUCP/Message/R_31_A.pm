package Protocol::EMIUCP::Message::R_31_A;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_A
);

use Mouse::Util::TypeConstraints;

has '+r'   => (                     required => 1, default => 'R');
has '+ot'  => (isa => enum(['31']), required => 1, default => '31');
has '+ack' => (                     required => 1, default => 'A');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_num4';

use constant list_data_field_names => [qw( sm )];

__PACKAGE__->meta->make_immutable();

1;
