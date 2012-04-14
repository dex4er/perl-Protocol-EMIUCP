package Protocol::EMIUCP::Message::Role::OT_31;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;
use Moose::Util::TypeConstraints;

use Protocol::EMIUCP::Field;

subtype EMIUCP_OT_31 => as    EMIUCP_Num2 => where { $_ == 31 };
coerce  EMIUCP_OT_31 => from 'EMIUCP_Num2';

has_field ot => (isa => 'EMIUCP_OT_31', default => '31');


1;
