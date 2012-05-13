package Protocol::EMIUCP::Message::R_60_A;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_6x_A
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  required => 1, default => 'R');
has '+ot'  => (isa => enum(['60']), required => 1, default => '60');
has '+ack' => (                     required => 1, default => 'A');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_str';

__PACKAGE__->meta->make_immutable();

1;
