#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More;

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP };

BEGIN { use_ok 'Protocol::EMIUCP::Message' };

sub test_message ($$$;$$) {
    my ($class, $str, $fields, $args, $code) = @_;
    $args = $fields unless defined $args;
    do {
        my $msg = Protocol::EMIUCP::Message->new_from_string($str);
        isa_ok $msg, $class;
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
        my $msg = Protocol::EMIUCP::Message->new(%$args);
        isa_ok $msg, $class;
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
    delete $args{$_} foreach (qw( amsg mt_description ));
    $args{mt} = eval 'MT_ALPHANUMERIC';
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
    my %args = %fields;
    delete $args{mt_description};
    $args{mt} = eval 'MT_NUMERIC';
    test_message 'Protocol::EMIUCP::Message::O_01', $str, \%fields, \%args;
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
    delete $args{$_} foreach (qw( sm sm_scts_datetime ));
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
        ec_description => 'Syntax Error',
        checksum       => '03',
    );
    my %args = %fields;
    delete $args{ec_description};
    $args{ec} = eval 'EC_SYNTAX_ERROR';
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
    delete $args{pid_description};
    $args{pid} = eval 'PID_PC_VIA_PSTN';
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
        ec_description => 'AdC Invalid',
        checksum       => '07',
    );
    my %args = %fields;
    delete $args{ec_description};
    $args{ec} = eval 'EC_ADC_INVALID';
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
    delete $args{$_} foreach (qw( nt_description npid_description vp_datetime mt_description amsg nadc ));
    %args = (
        %args,
        nadc => '192.87.34.12:5000',
        nt   => eval 'NT_ND',
        npid => eval 'NPID_PC_VIA_TCP_IP',
        mt   => eval 'MT_ALPHANUMERIC',
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
    delete $args{$_} foreach (qw( nt_description lpid_description ddt_datetime mt_description nb tmsg ));
    %args = (
        %args,
        nt   => eval 'NT_ND_DN_BN',
        lpid => eval 'LPID_FAX_GROUP_3',
        mt   => eval 'MT_TRANSPARENT',
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
    delete $args{$_} foreach (qw( sm sm_scts_datetime ));
    test_message 'Protocol::EMIUCP::Message::R_51_A', $str, \%fields, \%args;
};

# 5.3.2 Submit Short Message Operation (Negative Result) (p.37)
do {
    my $str = '00/00022/R/51/N/31//07';
    my %fields = (
        trn            => '00',
        len            => '00022',
        o_r            => 'R',
        ot             => '51',
        nack           => 'N',
        ec             => 31,
        ec_description => 'Fax Group Not Supported',
        checksum       => '07',
    );
    my %args = %fields;
    delete $args{ec_description};
    $args{ec} = eval 'EC_FAX_GROUP_NOT_SUPPORTED';
    test_message 'Protocol::EMIUCP::Message::R_51_N', $str, \%fields, \%args;
};

# 5.4 Delivery Short Message Operation -52 (p.39)
do {
    my $str = '00/00120/O/52/076523578/07686745/////////////120396111055////3//43616C6C20796F75206261636B206C617465722E///0//////////A3';
    my %fields = (
        trn              => '00',
        len              => '00120',
        o_r              => 'O',
        ot               => '52',
        adc              => '076523578',
        oadc             => '07686745',
        scts             => '120396111055',
        HAVE_DATETIME ? (scts_datetime => '1996-03-12T11:10:55') : (),
        mt               => 3,
        mt_description   => 'Alphanumeric',
        amsg             => '43616C6C20796F75206261636B206C617465722E',
        amsg_utf8        => 'Call you back later.',
        dcs              => '0',
        dcs_description  => 'Default Alphabet',
        checksum         => 'A3',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( scts_datetime mt_description amsg dcs_description ));
    %args = (
        %args,
        mt   => eval 'MT_ALPHANUMERIC',
        dcs  => eval 'DCS_DEFAULT_ALPHABET',
    );
    test_message 'Protocol::EMIUCP::Message::O_52', $str, \%fields, \%args;
};

# 5.4.1 Delivery Short Message Operation (Positive Result) (p.39)
do {
    my $str = '00/00039/R/52/A//076567:010196010101/6C';
    my %fields = (
        trn            => '00',
        len            => '00039',
        o_r            => 'R',
        ot             => '52',
        ack            => 'A',
        sm             => '076567:010196010101',
        sm_adc         => '076567',
        sm_scts        => '010196010101',
        HAVE_DATETIME ? (sm_scts_datetime => '1996-01-01T01:01:01') : (),
        checksum       => '6C',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( sm sm_scts_datetime ));
    test_message 'Protocol::EMIUCP::Message::R_52_A', $str, \%fields, \%args;
};

# 5.4.2 Delivery Short Message Operation (Negative Result) (p.39)
do {
    my $str = '00/00022/R/52/N/01//05';
    my %fields = (
        trn            => '00',
        len            => '00022',
        o_r            => 'R',
        ot             => '52',
        nack           => 'N',
        ec             => '01',
        ec_description => 'Checksum Error',
        checksum       => '05',
    );
    my %args = %fields;
    delete $args{ec_description};
    $args{ec} = eval 'EC_CHECKSUM_ERROR';
    test_message 'Protocol::EMIUCP::Message::R_52_N', $str, \%fields, \%args;
};

# 5.5 Delivery Notification Operation -53 (p.41)
do {
    my $str = '00/00234/O/53/1299998/3155555/////////////090196161057/1/108/090196161105/3//4D65737361676520666F7220333135353535352C2077697468206964656E74696669636174696F6E2039363031303931363130353720686173206265656E206275666665726564/////////////1F';
    my %fields = (
        trn              => '00',
        len              => '00234',
        o_r              => 'O',
        ot               => '53',
        adc              => '1299998',
        oadc             => '3155555',
        scts             => '090196161057',
        HAVE_DATETIME ? (scts_datetime => '1996-01-09T16:10:57') : (),
        dst              => 1,
        dst_description  => 'Buffered',
        rsn              => 108,
        dscts            => '090196161105',
        HAVE_DATETIME ? (dscts_datetime => '1996-01-09T16:11:05') : (),
        mt               => 3,
        mt_description   => 'Alphanumeric',
        amsg             => '4D65737361676520666F7220333135353535352C2077697468206964656E74696669636174696F6E2039363031303931363130353720686173206265656E206275666665726564',
        amsg_utf8        => 'Message for 3155555, with identification 960109161057 has been buffered',
        checksum         => '1F',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( scts_datetime dst_description dscts_datetime mt_description amsg ));
    %args = (
        %args,
        dst  => eval 'DST_BUFFERED',
        mt   => eval 'MT_ALPHANUMERIC',
    );
    test_message 'Protocol::EMIUCP::Message::O_53', $str, \%fields, \%args;
};

# 5.5.1 Delivery Notification Operation (Positive Result) (p.41)
do {
    my $str = '00/00032/R/53/A//020296020202/F2';
    my %fields = (
        trn            => '00',
        len            => '00032',
        o_r            => 'R',
        ot             => '53',
        ack            => 'A',
        sm             => '020296020202',
        sm_scts        => '020296020202',
        HAVE_DATETIME ? (sm_scts_datetime => '1996-02-02T02:02:02') : (),
        checksum       => 'F2',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( sm sm_scts_datetime ));
    test_message 'Protocol::EMIUCP::Message::R_53_A', $str, \%fields, \%args;
};

# 5.5.2 Delivery Notification Operation (Negative Result) (p.41)
do {
    my $str = '00/00022/R/53/N/02//07';
    my %fields = (
        trn            => '00',
        len            => '00022',
        o_r            => 'R',
        ot             => '53',
        nack           => 'N',
        ec             => '02',
        ec_description => 'Syntax Error',
        checksum       => '07',
    );
    my %args = %fields;
    delete $args{ec_description};
    $args{ec} = eval 'EC_SYNTAX_ERROR';
    test_message 'Protocol::EMIUCP::Message::R_53_N', $str, \%fields, \%args;
};

# 6.3 Session Management Operation -60 (p.57)
do {
    my $str = '02/00059/O/60/07656765/2/1/1/50617373776F7264//0100//////61';
    my %fields = (
        trn              => '02',
        len              => '00059',
        o_r              => 'O',
        ot               => '60',
        oadc             => '07656765',
        oton             => '2',
        oton_description => 'National',
        onpi             => '1',
        onpi_description => 'E.164 Address',
        styp             => '1',
        styp_description => 'Add item to MO-List',
        pwd              => '50617373776F7264',
        pwd_utf8         => 'Password',
        vers             => '0100',
        checksum         => '61',
    );
    my %args = %fields;
    delete $args{$_} foreach (qw( oton_description onpi_description styp_description pwd ));
    %args = (
        %args,
        oton => eval 'OTON_NATIONAL',
        onpi => eval 'ONPI_E_164_ADDRESS',
        styp => eval 'STYP_ADD_ITEM_TO_MO_LIST',
    );
    test_message 'Protocol::EMIUCP::Message::O_60', $str, \%fields, \%args;
};

# 6.3.1 Session Management Operation (Positive Result) (p.58)
do {
    my $str = '00/00019/R/60/A//6D';
    my %fields = (
        trn            => '00',
        len            => '00019',
        o_r            => 'R',
        ot             => '60',
        ack            => 'A',
        checksum       => '6D',
    );
    my %args = %fields;
    test_message 'Protocol::EMIUCP::Message::R_60_A', $str, \%fields, \%args;
};

# 6.3.2 Session Management Operation (Negative Result) (p.58)
do {
    my $str = '00/00022/R/60/N/01//04';
    my %fields = (
        trn            => '00',
        len            => '00022',
        o_r            => 'R',
        ot             => '60',
        nack           => 'N',
        ec             => '01',
        ec_description => 'Checksum Error',
        checksum       => '04',
    );
    my %args = %fields;
    delete $args{ec_description};
    $args{ec} = eval 'EC_CHECKSUM_ERROR';
    test_message 'Protocol::EMIUCP::Message::R_60_N', $str, \%fields, \%args;
};

done_testing();
