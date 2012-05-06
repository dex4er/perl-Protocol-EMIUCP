package Protocol::EMIUCP::Message::Role::Field::trn;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'trn' => (isa => 'EMIUCP_Num02', coerce => 1, required => 1, default => '00');

1;
