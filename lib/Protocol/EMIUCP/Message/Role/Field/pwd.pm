package Protocol::EMIUCP::Message::Role::Field::pwd;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Encode qw( from_hex_to_utf8 from_utf8_to_hex );

use Protocol::EMIUCP::Message::Field;

has_field 'pwd' => (
    isa       => 'EMIUCP_Hex16',
    lazy      => 1,
    default   => undef,
);

has 'pwd_utf8' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_pwd_utf8',
    trigger   => sub { $_[0]->{pwd} = from_utf8_to_hex $_[1] },
    lazy      => 1,
    default   => sub { defined $_[0]->{pwd} ? from_hex_to_utf8 $_[0]->{pwd} : undef }
);

1;
