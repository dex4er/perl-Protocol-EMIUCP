package Protocol::EMIUCP::Message::Role::Field::o_r;

use Moose::Role;

our $VERSION = '0.01';

use Moose::Util::TypeConstraints;

enum    'EMIUCP_O_R'     => [qw( O R )];

use Protocol::EMIUCP::Message::Field;

has_field 'o_r' => (isa => 'EMIUCP_O_R', required => 1);

1;
