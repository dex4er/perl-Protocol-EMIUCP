package Protocol::EMIUCP::Message::R_53_N;

use Mouse;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_53
    Protocol::EMIUCP::Message::Role::R_5x_N
);

__PACKAGE__->meta->make_immutable();

1;
