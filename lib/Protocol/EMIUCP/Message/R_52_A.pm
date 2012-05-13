package Protocol::EMIUCP::Message::R_52_A;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_A
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  required => 1, default => 'R');
has '+ot'  => (isa => enum(['52']), required => 1, default => '52');
has '+ack' => (                     required => 1, default => 'A');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_maybe_adc_scts';

__PACKAGE__->meta->make_immutable();

1;
