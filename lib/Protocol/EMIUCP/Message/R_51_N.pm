package Protocol::EMIUCP::Message::R_51_N;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_N
);

use Mouse::Util::TypeConstraints;

has '+r'    => (                     required => 1, default => 'R');
has '+ot'   => (isa => enum(['51']), required => 1, default => '51');
has '+nack' => (                     required => 1, default => 'N');

__PACKAGE__->meta->make_immutable();

1;
