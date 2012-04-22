#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More;

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP };

BEGIN { use_ok 'Protocol::EMIUCP' };

sub test_message ($$$;$$) {
    my ($class, $str, $fields, $args, $code) = @_;
    $args = $fields unless defined $args;
    do {
        my $msg = Protocol::EMIUCP->new_message_from_string($str);
        isa_ok $msg, $class;
        isa_ok $msg->validate, $class, "$str validated";
        is_deeply $msg->as_hashref, $fields, "$str fields matched";
        is $msg->as_string, $str, "$str as string matched";
        my $msg_hashref = $msg->as_hashref;
        isa_ok $msg_hashref, 'HASH';
        foreach (grep { defined $fields->{$_} } keys %$fields) {
            is $msg_hashref->{$_}, $fields->{$_}, $_
        };
        $code->($class, $str, $fields, $args, $msg) if $code;
    };
    do {
        my $msg = Protocol::EMIUCP->new_message(%$args);
        isa_ok $msg, $class;
        isa_ok $msg->validate, $class, "$str validated";
        is_deeply $msg->as_hashref, $fields, "$str fields matched";
        is $msg->as_string, $str, "$str as string matched";
        my $msg_hashref = $msg->as_hashref;
        isa_ok $msg_hashref, 'HASH';
        foreach (grep { defined $fields->{$_} } keys %$fields) {
            is $msg_hashref->{$_}, $fields->{$_}, $_
        };
        $code->($class, $str, $fields, $args, $msg) if $code;
    };
}

# 4.2 Call input Operation -01 (p.10)
do {
    my $str = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';
    my %fields = (
        trn            => '00',
        len            => '00070',
        o_r            => 'O',
        ot             => '01',
        adc            => '01234567890',
        oadc           => '09876543210',
        mt             => 3,
        mt_description => 'Alphanumeric',
        amsg           => '53686F7274204D657373616765',
        amsg_utf8      => 'Short Message',
        checksum       => 'D9',
    );
    my %args = %fields;
    delete $args{amsg};
    test_message 'Protocol::EMIUCP::Message::O_01', $str, \%fields, \%args;
};

# 4.2 Call input Operation -01 (p.10)
do {
    my $str = '00/00041/O/01/0888444///2/716436383334/C5';
    my %fields = (
        trn            => '00',
        len            => '00041',
        o_r            => 'O',
        ot             => '01',
        adc            => '0888444',
        mt             => 2,
        mt_description => 'Numeric',
        nmsg           => '716436383334',
        checksum       => 'C5',
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
        HAVE_DATETIME ? (sm_scts_datetime => '1996-01-09T10:32:58') : (),
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
        trn            => '12',
        len            => '00022',
        o_r            => 'R',
        ot             => '01',
        nack           => 'N',
        ec             => '02',
        ec_description => 'Syntax error',
        checksum       => '03',
    );
    my %args = %fields;
    delete $args{ec_message};
    $args{ec} = 'EC_SYNTAX_ERROR';
    test_message 'Protocol::EMIUCP::Message::R_01_N', $str, \%fields, \%args;
};

# 4.6 MT Alert Operation -31 (p.18)
do {
    my $str = '02/00035/O/31/0234765439845/0139/A0';
    my %fields = (
        trn             => '02',
        len             => '00035',
        o_r             => 'O',
        ot              => 31,
        adc             => '0234765439845',
        pid             => '0139',
        pid_description => 'PC via PSTN',
        checksum        => 'A0',
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
    test_message 'Protocol::EMIUCP::Message::R_31_A', $str, \%fields;
};

# 4.6.2 MT Alert Operation (Negative Result) (p.19)
do {
    my $str = '00/00022/R/31/N/06//07';
    my %fields = (
        trn            => '00',
        len            => '00022',
        o_r            => 'R',
        ot             => '31',
        nack           => 'N',
        ec             => '06',
        ec_description => 'AdC invalid',
        checksum       => '07',
    );
    my %args = %fields;
    delete $args{ec_message};
    $args{ec} = 'EC_ADC_INVALID';
    test_message 'Protocol::EMIUCP::Message::R_31_N', $str, \%fields, \%args;
};

# 5.3 Submit Short Message Operation -51 (p.36)
do {
    my $str = '18/00113/O/51/012345/09876//1/1920870340125000/4/0539//////3012961212//////3//4D657373616765203531/////////////CD';
    my %fields = (
        trn              => 18,
        len              => '00113',
        o_r              => 'O',
        ot               => '51',
        adc              => '012345',
        oadc             => '09876',
        nrq              => 1,
        nadc             => '1920870340125000',
        nadc_addr        => '192.87.34.12:5000',
        nt               => 4,
        nt_description   => 'ND',
        npid             => '0539',
        npid_description => 'PC via TCP/IP',
        vp               => '3012961212',
        HAVE_DATETIME ? (vp_datetime => '1996-12-30T12:12:00') : (),
        mt               => 3,
        mt_description   => 'Alphanumeric',
        amsg             => '4D657373616765203531',
        amsg_utf8        => 'Message 51',
        checksum         => 'CD',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( nt_description ntpid_description mt_description amsg nadc ));
    %args = (
        %args,
        nadc => '192.87.34.12:5000',
        nt   => 'NT_ND',
        npid => 'NPID_PC_VIA_TCP_IP',
        mt   => 'MT_ALPHANUMERIC',
    );
    test_message 'Protocol::EMIUCP::Message::O_51', $str, \%fields, \%args;
};

# 5.3 Submit Short Message Operation -51 (p.36)
do {
    my $str = '39/00099/O/51/0657467/078769//1//7//1/0545765/0122/1/0808971800///////4/32/F5AA34DE////1/////////65';
    my %fields = (
        trn              => '39',
        len              => '00099',
        o_r              => 'O',
        ot               => '51',
        adc              => '0657467',
        oadc             => '078769',
        nrq              => 1,
        nt               => 7,
        nt_description   => 'ND+DN+BN',
        lrq              => 1,
        lrad             => '0545765',
        lpid             => '0122',
        lpid_description => 'Fax Group 3',
        dd               => 1,
        ddt              => '0808971800',
        HAVE_DATETIME ? (ddt_datetime => '1997-08-08T18:00:00') : (),
        mt               => 4,
        mt_description   => 'Transparent',
        nb               => 32,
        tmsg             => 'F5AA34DE',
        tmsg_binary      => "\xF5\xAA\x34\xDE",
        mcls             => 1,
        checksum         => '65',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( nt_description lpid_description mt_description nb tmsg ));
    %args = (
        %args,
        nt   => 'NT_ND_DN_BN',
        lpid => 'LPID_FAX_GROUP_3',
        mt   => 'MT_TRANSPARENT',
    );
    test_message 'Protocol::EMIUCP::Message::O_51', $str, \%fields, \%args;
};

# 5.3.1 Submit Short Message Operation (Positive Result) (p.37)
do {
    my $str = '00/00039/R/51/A//012234:090996101010/68';
    my %fields = (
        trn            => '00',
        len            => '00039',
        o_r            => 'R',
        ot             => '51',
        ack            => 'A',
        sm             => '012234:090996101010',
        sm_adc         => '012234',
        sm_scts        => '090996101010',
        HAVE_DATETIME ? (sm_scts_datetime => '1996-09-09T10:10:10') : (),
        checksum       => '68',
    );
    my %args = %fields;
    delete $args{sm};
    test_message 'Protocol::EMIUCP::Message::R_51_A', $str, \%fields, \%args;
};

done_testing();
