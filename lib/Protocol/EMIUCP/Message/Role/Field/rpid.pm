package Protocol::EMIUCP::Message::Role::Field::rpid;

use Mouse::Role;

our $VERSION = '0.01';

use Mouse::Util::TypeConstraints;
use Protocol::EMIUCP::Message::Field;

has_field 'rpid' => (isa => enum([ map { sprintf '%04d', $_ } 0..71, 95, 127, 192..255 ]));

1;
