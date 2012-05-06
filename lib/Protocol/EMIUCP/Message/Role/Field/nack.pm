package Protocol::EMIUCP::Message::Role::Field::nack;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum    'EMIUCP_N'       => [qw( N )];
coerce  'EMIUCP_N'       => from 'Bool' => via   { $_ ? 'N' : '' };

use Protocol::EMIUCP::Message::Field;

has_field 'nack' => (isa => 'EMIUCP_N', coerce => 1, required => 1, default => 'N');

1;
