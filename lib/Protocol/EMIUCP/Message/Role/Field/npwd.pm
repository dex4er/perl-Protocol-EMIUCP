package Protocol::EMIUCP::Message::Role::Field::npwd;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Encode qw( from_hex_to_utf8 from_utf8_to_hex );

use Protocol::EMIUCP::Message::Field;

has_field 'npwd' => (isa => 'EMIUCP_Hex16');

has 'npwd_utf8' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_npwd_utf8',
    trigger   => sub { $_[0]->{npwd} = from_utf8_to_hex $_[1] },
    lazy      => 1,
    default   => sub { defined $_[0]->{npwd} ? from_hex_to_utf8 $_[0]->{npwd} : undef }
);

1;
