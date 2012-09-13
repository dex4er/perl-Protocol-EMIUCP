package Protocol::EMIUCP::Message::Role::Field::r;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum    'EMIUCP_R'       => [qw( R )];
coerce  'EMIUCP_R'       => from 'Bool' => via { $_ ? 'R' : '' };

use Protocol::EMIUCP::Message::Field;

has_field 'r' => (isa => 'EMIUCP_R', coerce => 1);

1;
