package Protocol::EMIUCP::Message::Role::Field::adc;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'adc' => (isa => 'EMIUCP_Num16');

1;
