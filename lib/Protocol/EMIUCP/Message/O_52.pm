package Protocol::EMIUCP::Message::O_52;

use Moose;
use MooseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::O_5x
);

use Moose::Util::TypeConstraints;

has '+o_r' => (isa => enum(['O']),  default => 'O');
has '+ot'  => (isa => enum(['52']), default => '52');

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc scts )];
empty_field [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp dst rsn dscts pr cpg rply otoa
    res4 res5
)];

__PACKAGE__->meta->make_immutable();

1;
