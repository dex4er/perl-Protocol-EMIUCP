package Protocol::EMIUCP::Message::Role::OT_01;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;
use Moose::Util::TypeConstraints;

use Protocol::EMIUCP::Field;

subtype EMIUCP_OT_01 => as    EMIUCP_Num2 => where { $_ == 1 };
coerce  EMIUCP_OT_01 => from 'EMIUCP_Num2';

has_field ot => (isa => 'EMIUCP_OT_01', default => '01');


1;
