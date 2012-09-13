package Protocol::EMIUCP::Message::R_53_N;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_N
);

use Mouse::Util::TypeConstraints;

has '+r'    => (                     required => 1, default => 'R');
has '+ot'   => (isa => enum(['53']), required => 1, default => '53');
has '+nack' => (                     required => 1, default => 'N');

__PACKAGE__->meta->make_immutable();

1;
