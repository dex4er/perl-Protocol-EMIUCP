package Protocol::EMIUCP::Message::Role::Field::oadc_num;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'oadc' => (isa => 'EMIUCP_Num16');

1;
