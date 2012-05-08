package Protocol::EMIUCP::Message::R_52_N;

use Moose;
use MooseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_N
);

use Moose::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['52']), default => '52');

__PACKAGE__->meta->make_immutable();

1;
