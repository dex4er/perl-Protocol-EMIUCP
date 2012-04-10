package Protocol::EMIUCP::Field;

use 5.008;

our $VERSION = '0.01';

use Moose;

has ac       => (
    is => 'ro',
    isa => 'Str',
);

has ack      => (
    is        => 'ro',
    isa       => 'ACK',
    coerce    => 1,
    default   => 'A',
);

has adc      => (
    is  => 'ro',
    isa => 'Num16',
);

has amsg     => (
    is        => 'ro',
    isa       => 'Protocol::EMIUCP::Field::amsg',
    coerce    => 1,
    predicate => 'has_amsg',
    handles   => {
        amsg_as_string => 'value',
        amsg_utf8      => 'utf8',
    },
);

has checksum => (
    is        => 'ro',
    isa       => 'Hex2',
    coerce    => 1,
    writer    => '_set_checksum',
    predicate => 'has_checksum',
    clearer   => '_clear_checksum',
);

has ec        => (
    is        => 'ro',
    # TODO isa
); 

has len      => (
    is        => 'ro',
    isa       => 'Int5',
    coerce    => 1,
    writer    => '_set_len',
    predicate => 'has_len',
);

has mt       => (
    is => 'ro',
    isa => 'MT23',
    required => 1,
);

has nack     => (
    is        => 'ro',
    isa       => 'NACK',
    coerce    => 1,
    default   => 'N',
);

has nmsg     => (
    is => 'ro',
    isa => 'Num160',
    predicate => 'has_nmsg',
);

has o_r      => (
    is        => 'ro',
    isa       => 'O_R',
    required  => 1
);

has oadc     => (
    is => 'ro',
    isa => 'Num16',
);

has ot       => (
    is        => 'ro',
    isa       => 'Int2',
    coerce    => 1,
    required  => 1,
);

has sm       => (
    is        => 'ro',
    isa       => 'Protocol::EMIUCP::Field::sm',
    coerce    => 1,
    predicate => 'has_sm',
    handles   => {
        sm_as_string => 'as_string',
        sm_adc       => 'adc',
        sm_scts      => 'scts',
    },
);

has trn      => (
    is        => 'ro',
    isa       => 'Int2',
    coerce    => 1,
    default   => '00',
);


1;
