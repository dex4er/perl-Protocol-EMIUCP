package Protocol::EMIUCP::Message::Role::Field::o_r;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'o_r' => (isa => enum([qw( O R )]));

1;
