package Protocol::EMIUCP::Message::O_60;

use Mouse;
use MouseX::StrictConstructor;

our $VERSION = '0.01';

with qw(
    Protocol::EMIUCP::Message::Role
    Protocol::EMIUCP::Message::Role::O_6x
);

use Mouse::Util::TypeConstraints;

has '+o_r' => (isa => enum(['O']),  default => 'O');
has '+ot'  => (isa => enum(['60']), default => '60');

use Protocol::EMIUCP::Message::Field;

required_field [qw( oadc styp pwd vers )];
empty_field [qw( ladc lton lnpi res1 )];

__PACKAGE__->meta->make_immutable();

1;
