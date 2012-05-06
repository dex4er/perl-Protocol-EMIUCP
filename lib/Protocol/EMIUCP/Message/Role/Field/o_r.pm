package Protocol::EMIUCP::Message::Role::Field::o_r;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum    'EMIUCP_O_R'     => [qw( O R )];

use Protocol::EMIUCP::Message::Field;

has_field 'o_r' => (isa => 'EMIUCP_O_R', required => 1);

1;
