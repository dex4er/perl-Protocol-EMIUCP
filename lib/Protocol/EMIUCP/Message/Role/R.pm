package Protocol::EMIUCP::Message::Role::R;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;
use Moose::Util::TypeConstraints;
with 'Protocol::EMIUCP::Message::Role::Base';

use Protocol::EMIUCP::Field;

enum EMIUCP_R => [qw( R )];

has_field o_r => (isa => 'EMIUCP_R', default => 'R');


1;
