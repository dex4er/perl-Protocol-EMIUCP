package Protocol::EMIUCP::Message::Role::Field::ot;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'ot' => (isa => 'EMIUCP_Num02', coerce => 1, required => 1);

1;
