package Protocol::EMIUCP::Message::O_52;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::O_5x
);

use Mouse::Util::TypeConstraints;

has '+o'  => (                     required => 1, default => 'O');
has '+ot' => (isa => enum(['52']), required => 1, default => '52');

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc scts )];
empty_field [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp dst rsn dscts pr cpg rply otoa
    res4 res5
)];

__PACKAGE__->meta->make_immutable();

1;
