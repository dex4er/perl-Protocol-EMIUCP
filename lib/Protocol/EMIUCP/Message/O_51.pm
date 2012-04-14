package Protocol::EMIUCP::Message::O_51;

use 5.006;

our $VERSION = '0.01';

use Moose;

with 'Protocol::EMIUCP::Message::Role::O';
with 'Protocol::EMIUCP::Message::Role::OT_51';

use Protocol::EMIUCP::Types::oadc;
use Protocol::EMIUCP::Field;

has_field  adc  => (required => 1);
with_field oadc => (
    isa      => 'Protocol::EMIUCP::Types::oadc',
    coerce   => 1,
    required => 1,
    handles  => {
        oadc_string      => 'as_string',
        oadc_is_alphanum => 'is_alphanum',
        oadc_utf8        => 'utf8',
    },
);
has_field [qw( ac )];
#has_field [qw( ac nrq nadc nt npid lrq lrad lpid dd ddt vp rpid )];

__PACKAGE__->meta->make_immutable();

1;
