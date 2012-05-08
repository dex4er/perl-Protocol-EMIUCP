package Protocol::EMIUCP::Message::R_53_N;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_N
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['53']), default => '53');

__PACKAGE__->meta->make_immutable();

1;
