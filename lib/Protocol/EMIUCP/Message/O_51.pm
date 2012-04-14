package Protocol::EMIUCP::Message::O_51;

use 5.006;

our $VERSION = '0.01';

use Moose;

with 'Protocol::EMIUCP::Message::Role::O';
with 'Protocol::EMIUCP::Message::Role::OT_51';

use Protocol::EMIUCP::Types::oadc;
use Protocol::EMIUCP::Types::nt;
use Protocol::EMIUCP::Field;

has_field  adc  => (required => 1);
with_field oadc => (
    isa      => 'Protocol::EMIUCP::Types::oadc',
    coerce   => 1,
    required => 1,
    predicate => 'has_oadc',
    handles  => {
        oadc_string      => 'as_string',
        oadc_is_alphanum => 'is_alphanum',
        oadc_utf8        => 'utf8',
    },
);
has_field ['ac', 'nrq', 'nadc'];
with_field 'nt';
with_field 'npid';
has_field ['lrq', 'lrad'];
with_field 'lpid';
has_field  'dd';

sub list_npid_codes {
    return qw( 0100 0122 0131 0138 0139 0339 0439 0539 );
};

sub list_lpid_codes {
    return qw( 0100 0122 0131 0138 0139 0339 0439 0539 );
};


__PACKAGE__->meta->make_immutable();

1;
