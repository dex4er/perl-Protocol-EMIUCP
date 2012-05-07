package Protocol::EMIUCP::Message::R_52_N;

use Moose;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_52
    Protocol::EMIUCP::Message::Role::R_5x_N
);

__PACKAGE__->meta->make_immutable();

1;
