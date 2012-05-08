package Protocol::EMIUCP::Message::R_60_N;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_6x_N
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['60']), default => '60');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_str';

__PACKAGE__->meta->make_immutable();

1;
