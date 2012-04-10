package Protocol::EMIUCP::Field;

use 5.008;

our $VERSION = '0.01';

use constant fields => {
    adc      => {is => 'ro', isa => 'Num16'},
    oadc     => {is => 'ro', isa => 'Num16'},
    ac       => {is => 'ro', isa => 'Str'},
    mt       => {is => 'ro', isa => 'MT23', required => 1},
    nmsg     => {is => 'ro', isa => 'Num160', predicate => 'has_nmsg'},
    ec       => {is => 'ro'}, # TODO isa
    ack      => (is => 'ro', isa => 'ACK', coerce => 1, default => 'A');
    amsg     => {
        is        => 'ro',
        isa       => 'Protocol::EMIUCP::Field::amsg',
        coerce    => 1,
        predicate => 'has_amsg',
        handles   => {
            amsg_as_string => 'value',
            amsg_utf8      => 'utf8',
        },
    },
    trn      => {is => 'ro', isa => 'Int2', coerce => 1, default => 0};
    len      => {is => 'ro', isa => 'Int5', coerce => 1, writer => '_set_len', predicate => 'has_len'};
    checksum => {is => 'ro', isa => 'Hex2', coerce => 1, writer => '_set_checksum', predicate => 'has_checksum', clearer => '_clear_checksum'};
    nack     => {is => 'ro', isa => 'NACK', coerce => 1, default => 'N'};
    o_r      => {is => 'ro', isa => 'O_R', default => 'O', required => 1};
    ot       => {is => 'ro', isa => 'Int2', default => '01', required => 1, coerce => 1};
    o_r      => {is => 'ro', isa => 'O_R', default => 'R', required => 1};
    sm => {
        is        => 'ro',
        isa       => 'Protocol::EMIUCP::Field::sm',
        coerce    => 1,
        predicate => 'has_sm',
        handles   => {
            sm_as_string => 'as_string',
            sm_adc       => 'adc',
            sm_scts      => 'scts',
        },
    },
};


1;
