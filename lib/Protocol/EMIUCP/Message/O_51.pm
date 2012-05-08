package Protocol::EMIUCP::Message::O_51;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::O_5x
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['O']),  default => 'O');
has '+ot'  => (isa => enum(['51']), default => '51');

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc mt )];
empty_field [qw( scts dst rsn dscts dcs cpg rply hplmn res4 res5 )];

has '+npid' => (isa => enum([qw( 0100 0122 0131 0138 0139 0339 0439 0539 )]));
has '+lpid' => (isa => enum([qw( 0100 0122 0131 0138 0139 0339 0439 0539 )]));

__PACKAGE__->meta->make_immutable();

1;
