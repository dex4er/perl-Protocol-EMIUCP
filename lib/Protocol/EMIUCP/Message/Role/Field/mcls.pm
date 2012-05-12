package Protocol::EMIUCP::Message::Role::Field::mcls;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'mcls' => (isa => enum([ 0 .. 3]));

1;
