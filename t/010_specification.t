#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 33;

BEGIN { use_ok 'Protocol::EMIUCP' };

sub test_message ($$$;$$) {
    my ($class, $str, $args, $obj, $code) = @_;
    $obj = $args unless $obj;
    do {
        my $msg = Protocol::EMIUCP->new_message_from_string($str);
        isa_ok $msg, $class;
        is_deeply $msg, $obj, "$str is parsed";
        is $msg->to_string, $str, "$str is serialized";
        $code->($class, $str, $args, $obj, $msg) if $code;
    };
    do {
        my $msg = Protocol::EMIUCP->new_message(%$args);
        isa_ok $msg, $class;
        is_deeply $msg, $obj, "$str is parsed";
        is $msg->to_string, $str, "$str is serialized";
        $code->($class, $str, $args, $obj, $msg) if $code;
    };
}

# 4.2 Call input Operation -01 (p.22)
do {
    my $str = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';
    my %args = (
        trn      => '00',
        len      => '00070',
        o_r      => 'O',
        ot       => '01',
        adc      => '01234567890',
        oadc     => '09876543210',
        mt       => 3,
        amsg     => '53686F7274204D657373616765',
        checksum => 'D9',
    );
    test_message 'Protocol::EMIUCP::Message::O_01', $str, \%args, \%args, sub {
        my ($class, $str, $args, $obj, $msg) = @_;
        is $msg->amsg_to_string, 'Short Message', "amsg_to_string for $args->{amsg}";
    };
    do {
        my %args2 = %args;
        delete $args2{amsg};
        $args2{amsg_from_string} = 'Short Message';
        test_message 'Protocol::EMIUCP::Message::O_01', $str, \%args2, \%args;
    };
};

# 4.2 Call input Operation -01 (p.22)
do {
    my $str = '00/00041/O/01/0888444///2/716436383334/C5';
    my %args = (
        trn      => '00',
        len      => '00041',
        o_r      => 'O',
        ot       => '01',
        adc      => '0888444',
        mt       => 2,
        nmsg     => '716436383334',
        checksum => 'C5',
    );
    test_message 'Protocol::EMIUCP::Message::O_01', $str, \%args;
};

# 4.2.1 Call Input Operation (Positive Result) (p.23)
do {
    my $str = '06/00043/R/01/A/01234567890:090196103258/4E';
    my %args = (
        trn      => '06',
        len      => '00043',
        o_r      => 'R',
        ot       => '01',
        ack      => 'A',
        sm       => '01234567890:090196103258',
        checksum => '4E',
    );
    test_message 'Protocol::EMIUCP::Message::R_01_A', $str, \%args;
};

# 4.2.2 Call Input Operation (Negative Result) (p.23)
do {
    my $str = '12/00022/R/01/N/02//03';
    my %args = (
        trn      => '12',
        len      => '00022',
        o_r      => 'R',
        ot       => '01',
        nack     => 'N',
        ec       => '02',
        checksum => '03',
    );
    test_message 'Protocol::EMIUCP::Message::R_01_N', $str, \%args;
};
