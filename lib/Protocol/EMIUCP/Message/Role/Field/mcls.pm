package Protocol::EMIUCP::Message::Role::Field::mcls;

use Moose::Role;

our $VERSION = '0.01';

use Moose::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'mcls' => (isa => enum([ 0 .. 3]));

1;
