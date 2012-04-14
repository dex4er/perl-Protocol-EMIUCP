package Protocol::EMIUCP::Message::Role::OT_51;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;
use Moose::Util::TypeConstraints;

with 'Protocol::EMIUCP::Message::Role::OT_50';

use Protocol::EMIUCP::Field;

enum    EMIUCP_OT_51 => [qw( 51 )];
coerce  EMIUCP_OT_51 => from 'EMIUCP_Num02';

has_field ot => (isa => 'EMIUCP_OT_51', default => '51');


1;
