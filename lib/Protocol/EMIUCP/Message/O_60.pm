package Protocol::EMIUCP::Message::O_60;

use Moose;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_60
    Protocol::EMIUCP::Message::Role::O_6x
);

use Protocol::EMIUCP::Message::Field;

required_field [qw( oadc styp pwd vers )];
empty_field [qw( ladc lton lnpi res1 )];

__PACKAGE__->meta->make_immutable();

1;
