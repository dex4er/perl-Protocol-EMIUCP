package Protocol::EMIUCP::Message::R_51_A;

use Moose;
use MooseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::R_5x_A
);

use Moose::Util::TypeConstraints;

has '+o_r' => (isa => enum(['R']),  default => 'R');
has '+ot'  => (isa => enum(['51']), default => '51');

use Protocol::EMIUCP::Message::Field;

with_field 'sm_adc_scts';

__PACKAGE__->meta->make_immutable();

1;
