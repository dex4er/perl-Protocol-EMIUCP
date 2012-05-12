package Protocol::EMIUCP::Message::Role::Field::amsg;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Encode qw( from_hex_to_utf8 from_utf8_to_hex );

use Protocol::EMIUCP::Message::Field;

has_field 'amsg' => (
    isa       => 'EMIUCP_Hex640',
    trigger   => sub {
        confess "Attribute (amsg) is invalid, should be undefined if mt != 3"
            if defined $_[0]->{mt} and $_[0]->{mt} ne 3;
    },
);

has 'amsg_utf8' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_amsg_utf8',
    trigger   => sub { $_[0]->{amsg} = from_utf8_to_hex $_[1] },
    lazy      => 1,
    default   => sub { defined $_[0]->{amsg} ? from_hex_to_utf8 $_[0]->{amsg} : undef },
);

1;
