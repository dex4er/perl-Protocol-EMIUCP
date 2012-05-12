package Protocol::EMIUCP::Message::Role::Field::tmsg;

use Mouse::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Encode qw( decode_hex encode_hex );

use Protocol::EMIUCP::Message::Field;

has_field 'tmsg' => (
    isa       => 'EMIUCP_Hex1403',
    trigger   => sub {
        confess "Attribute (tmsg) is invalid, should be undefined if mt != 4"
            if defined $_[0]->{mt} and $_[0]->{mt} ne 4;
    },
);

has 'tmsg_binary' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_amsg_utf8',
    trigger   => sub {
        $_[0]->{tmsg} = encode_hex $_[1];
        $_[0]->{nb}   = 4 * length $_[0]->{tmsg};
    },
    lazy      => 1,
    default   => sub { defined $_[0]->{tmsg} ? decode_hex $_[0]->{tmsg} : undef },
);

1;
