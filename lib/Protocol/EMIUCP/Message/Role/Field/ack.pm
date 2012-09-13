package Protocol::EMIUCP::Message::Role::Field::ack;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum    'EMIUCP_A'       => [qw( A )];
coerce  'EMIUCP_A'       => from 'Bool' => via { $_ ? 'A' : '' };

use Protocol::EMIUCP::Message::Field;

has_field 'ack' => (isa => 'EMIUCP_A', coerce => 1);

1;
