package Protocol::EMIUCP::Message::Role::Field::mvp;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'mvp' => (isa => 'EMIUCP_Str');

1;
