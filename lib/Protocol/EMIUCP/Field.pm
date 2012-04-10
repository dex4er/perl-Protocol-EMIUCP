package Protocol::EMIUCP::Field;

use 5.008;

our $VERSION = '0.01';

use Exporter ();
our @EXPORT = qw(has_field);
sub import {
    goto \&Exporter::import;
};

use constant fields => {

    ac       => {
        is        => 'ro',
        isa       => 'Str',
    },

    ack      => {
        is        => 'ro',
        isa       => 'ACK',
        coerce    => 1,
        required  => 1,
        default   => 'A',
    },

    adc      => {
        is        => 'ro',
        isa       => 'Num16',
        required  => 1,
    },

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

    checksum => {
        is        => 'ro',
        isa       => 'Hex2',
        coerce    => 1,
        writer    => '_set_checksum',
        predicate => 'has_checksum',
        clearer   => '_clear_checksum',
    },

    ec        => {
        is        => 'ro',
        isa       => 'Num2',
        required  => 1,
    },

    len      => {
        is        => 'ro',
        isa       => 'Int5',
        coerce    => 1,
        writer    => '_set_len',
        predicate => 'has_len',
    },

    mt       => {
        is        => 'ro',
        isa       => 'MT23',
        required  => 1,
    },

    nack     => {
        is        => 'ro',
        isa       => 'NACK',
        coerce    => 1,
        required  => 1,
        default   => 'N',
    },

    nmsg     => {
        is        => 'ro',
        isa       => 'Num160',
        predicate => 'has_nmsg',
    },

    o_r      => {
        is        => 'ro',
        isa       => 'O_R',
        required  => 1
    },

    oadc     => {
        is        => 'ro',
        isa       => 'Num16',
    },

    ot       => {
        is        => 'ro',
        isa       => 'Int2',
        coerce    => 1,
        required  => 1,
    },

    sm       => {
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

    trn      => {
        is        => 'ro',
        isa       => 'Int2',
        coerce    => 1,
        default   => '00',
    },

};


use Protocol::EMIUCP::Types;

sub has_field ($;@) {
    my ($name, @props) = @_;
    if (ref $name and ref $name eq 'ARRAY') {
        caller()->meta->add_attribute(
            $_ => %{ Protocol::EMIUCP::Field::fields->{$_} }, @props
        ) foreach @$name;
    }
    else {
        caller()->meta->add_attribute(
            $name => %{ Protocol::EMIUCP::Field::fields->{$name} }, @props
        );
    };
};


1;
