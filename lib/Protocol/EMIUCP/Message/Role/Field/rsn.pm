package Protocol::EMIUCP::Message::Role::Field::rsn;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;

enum   'EMIUCP_Rsn' => [ map { sprintf '%03d', $_ } ( 0 .. 255 ) ];
coerce 'EMIUCP_Rsn' => from 'Num' => via { sprintf '%03d', $_ };

use Protocol::EMIUCP::Message::Field;

has_field 'rsn' => (isa => 'EMIUCP_Rsn');

1;
