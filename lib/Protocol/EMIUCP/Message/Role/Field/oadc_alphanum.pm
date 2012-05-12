package Protocol::EMIUCP::Message::Role::Field::oadc_alphanum;

use Moose::Role;

our $VERSION = '0.01';

use Protocol::EMIUCP::Encode qw( from_7bit_hex_to_utf8 from_utf8_to_7bit_hex );

use Protocol::EMIUCP::Message::Field;

has_field 'oadc' => (
    isa => 'EMIUCP_Num16 | EMIUCP_Hex22',
    trigger   => sub {
        if (defined $_[0]->{otoa} and $_[0]->{otoa} eq '5039') {
            confess "Attribute (oadc) is invalid with value " . $_[1]
                unless $_[1] =~ /^[\dA-F]{2,22}$/;
        }
        else {
            confess "Attribute (oadc) is invalid with value " . $_[1]
                unless $_[1] =~ /^\d{1,16}$/;
        };
    },
);

has 'oadc_utf8' => (
    isa       => 'Maybe[Str]',
    is        => 'ro',
    predicate => 'has_oadc_utf8',
    trigger   => sub { $_[0]->{oadc} = from_utf8_to_7bit_hex $_[1] },
    lazy      => 1,
    default   => sub {
        defined $_[0]->{oadc} and ($_[0]->{otoa}||0) eq '5039'
            ? from_7bit_hex_to_utf8 $_[0]->{oadc} : undef
    },
);

1;
