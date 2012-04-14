package Protocol::EMIUCP::Message::Role::O;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
use Moose::Util::TypeConstraints;
with 'Protocol::EMIUCP::Message::Role::Base';

use Protocol::EMIUCP::Field;

enum EMIUCP_O => [qw( O )];

has_field o_r => (isa => 'EMIUCP_O', default => 'O');


1;
