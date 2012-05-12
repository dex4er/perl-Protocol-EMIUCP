package Protocol::EMIUCP::Message::Role::Field::nmsg;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Message::Field;

has_field 'nmsg' => (
    isa => 'EMIUCP_Num160',
    trigger => sub {
        confess "Attribute (nmsg) is invalid, should be undefined if mt != 2"
            if defined $_[0]->{mt} and $_[0]->{mt} ne 2;
    },
);

1;
