package Protocol::EMIUCP::Message::Role::Field::pr;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'pr' => (isa => 'EMIUCP_Str');

1;
