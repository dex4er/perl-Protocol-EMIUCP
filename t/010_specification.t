#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 13;

BEGIN { use_ok 'Protocol::EMIUCP' };

sub test_message ($$%) {
    my ($class, $str, %args) = @_;
    do {
        my $msg = Protocol::EMIUCP->new_message_from_string($str);
        isa_ok $msg, 'Protocol::EMIUCP::Message::O_01';
        is_deeply $msg, \%args, "$str is parsed";
        is $msg->to_string, $str, "$str is serialized";
    };
    do {
        my $msg = Protocol::EMIUCP->new_message(%args);
        isa_ok($msg, 'Protocol::EMIUCP::Message::O_01');
        is_deeply($msg, \%args, "$str is parsed");
        is $msg->to_string, $str, "$str is serialized";
    };
}

# 4.2. Call input Operation -01 (p.22)
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
    test_message 'Protocol::EMIUCP::Message::O_01', $str, %args;
};

# 4.2. Call input Operation -01 (p.22)
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
    test_message 'Protocol::EMIUCP::Message::O_01', $str, %args;
};
