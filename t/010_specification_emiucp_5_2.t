#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 137;

BEGIN { use_ok 'Protocol::EMIUCP' };

sub test_message ($$$;$$) {
    my ($class, $str, $fields, $args, $code) = @_;
    $args = $fields unless defined $args;
    do {
        my $msg = Protocol::EMIUCP->new_message_from_string($str);
        isa_ok $msg, $class;
        is_deeply $msg->as_hashref, $fields, "$str fields matched";
        is $msg->as_string, $str, "$str as string matched";
        foreach (grep { defined $fields->{$_} } keys %$fields) {
            is $msg->$_, $fields->{$_}, $_
        };
        $code->($class, $str, $fields, $args, $msg) if $code;
    };
    do {
        my $msg = Protocol::EMIUCP->new_message(%$args);
        isa_ok $msg, $class;
        is_deeply $msg->as_hashref, $fields, "$str fields matched";
        is $msg->as_string, $str, "$str as string matched";
        foreach (grep { defined $fields->{$_} } keys %$fields) {
            is $msg->$_, $fields->{$_}, $_
        };
        $code->($class, $str, $fields, $args, $msg) if $code;
    };
}

# 4.2 Call input Operation -01 (p.10)
do {
    my $str = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';
    my %fields = (
        trn       => '00',
        len       => '00070',
        o_r       => 'O',
        ot        => '01',
        adc       => '01234567890',
        oadc      => '09876543210',
        mt        => 3,
        amsg      => '53686F7274204D657373616765',
        amsg_utf8 => 'Short Message',
        checksum  => 'D9',
    );
    my %args = %fields;
    delete $args{amsg};
    test_message 'Protocol::EMIUCP::Message::O_01', $str, \%fields, \%args;
};

# 4.2 Call input Operation -01 (p.10)
do {
    my $str = '00/00041/O/01/0888444///2/716436383334/C5';
    my %fields = (
        trn      => '00',
        len      => '00041',
        o_r      => 'O',
        ot       => '01',
        adc      => '0888444',
        mt       => 2,
        nmsg     => '716436383334',
        checksum => 'C5',
    );
    test_message 'Protocol::EMIUCP::Message::O_01', $str, \%fields;
};

# 4.2.1 Call Input Operation (Positive Result) (p.11)
do {
    my $str = '06/00043/R/01/A/01234567890:090196103258/4E';
    my %fields = (
        trn      => '06',
        len      => '00043',
        o_r      => 'R',
        ot       => '01',
        ack      => 'A',
        sm       => '01234567890:090196103258',
        sm_adc   => '01234567890',
        sm_scts  => '090196103258',
        checksum => '4E',
    );
    my %args = %fields;
    delete $args{sm};
    test_message 'Protocol::EMIUCP::Message::R_01_A', $str, \%fields, \%args;
};

# 4.2.2 Call Input Operation (Negative Result) (p.11)
do {
    my $str = '12/00022/R/01/N/02//03';
    my %fields = (
        trn        => '12',
        len        => '00022',
        o_r        => 'R',
        ot         => '01',
        nack       => 'N',
        ec         => '02',
        ec_message => 'Syntax error',
        checksum   => '03',
    );
    test_message 'Protocol::EMIUCP::Message::R_01_N', $str, \%fields;
};

# 4.6 MT Alert Operation -31 (p.18)
do {
    my $str = '02/00035/O/31/0234765439845/0139/A0';
    my %fields = (
        trn         => '02',
        len         => '00035',
        o_r         => 'O',
        ot          => 31,
        adc         => '0234765439845',
        pid         => '0139',
        pid_message => 'PC via PSTN',
        checksum    => 'A0',
    );
    my %args = %fields;
    delete $args{pid_message};
    $args{pid} = 'PID_PC_VIA_PSTN';
    test_message 'Protocol::EMIUCP::Message::O_31', $str, \%fields, \%args;
};

# 4.6.1 MT Alert Operation (Positive Result) (p.19)
do {
    my $str = '04/00023/R/31/A/0003/2D';
    my %fields = (
        trn      => '04',
        len      => '00023',
        o_r      => 'R',
        ot       => '31',
        ack      => 'A',
        sm       => '0003',
        checksum => '2D',
    );
    my %args = %fields;
    test_message 'Protocol::EMIUCP::Message::R_31_A', $str, \%fields, \%args;
};
