package Protocol::EMIUCP::Message::R_51_A;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_A
);

use Mouse::Util::TypeConstraints;

has '+r'   => (                     required => 1, default => 'R');
has '+ot'  => (isa => enum(['51']), required => 1, default => '51');
has '+ack' => (                     required => 1, default => 'A');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_adc_scts';

__PACKAGE__->meta->make_immutable();

1;
