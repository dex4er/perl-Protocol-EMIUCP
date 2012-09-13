package Protocol::EMIUCP::Message::Role::Field::o;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum    'EMIUCP_O'       => [qw( O )];
coerce  'EMIUCP_O'       => from 'Bool' => via { $_ ? 'O' : '' };

use Protocol::EMIUCP::Message::Field;

has_field 'o' => (isa => 'EMIUCP_O', coerce => 1);

1;
