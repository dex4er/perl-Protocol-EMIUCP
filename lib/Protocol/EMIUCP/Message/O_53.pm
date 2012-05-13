package Protocol::EMIUCP::Message::O_53;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::O_5x
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['O']),  required => 1, default => 'O');
has '+ot'  => (isa => enum(['53']), required => 1, default => '53');

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc scts dst rsn dscts mt )];
empty_field [qw(
    ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid pr dcs mcls rpl cpg rply
    otoa xser res4 res5
)];

__PACKAGE__->meta->make_immutable();

1;
