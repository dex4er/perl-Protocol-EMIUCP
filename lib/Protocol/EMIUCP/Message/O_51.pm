package Protocol::EMIUCP::Message::O_51;

use Mouse;

our $VERSION = '0.01';

extends qw(Protocol::EMIUCP::Message::Object);
with qw(
    Protocol::EMIUCP::Message::Role::OT_51
    Protocol::EMIUCP::Message::Role::O_5x
);

use Protocol::EMIUCP::Message::Field;

required_field [qw( adc oadc mt )];
empty_field [qw( scts dst rsn dscts dcs cpg rply hplmn res4 res5 )];

use constant list_valid_npid_values => [qw( 0100 0122 0131 0138 0139 0339 0439 0539 )];
use constant list_valid_lpid_values => [qw( 0100 0122 0131 0138 0139 0339 0439 0539 )];

__PACKAGE__->meta->make_immutable();

1;
