package Protocol::EMIUCP::Message::Role::Field::mcls;

use Moose::Role;

our $VERSION = '0.01';

use Moose::Util::TypeConstraints;

enum 'EMIUCP_MCLs' => [( 0 .. 3 )];

use Protocol::EMIUCP::Message::Field;

has_field 'mcls' => (isa => 'EMIUCP_MCLs');

1;
