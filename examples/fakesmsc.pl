#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP;

use IO::Handle;
use IO::Select;

my $fhin = *STDIN{IO};
my $selin = IO::Select->new($fhin);

my $fhout = *STDOUT{IO};
my $selout = IO::Select->new($fhout);

my $rbuf = my $wbuf = my $eof = '';

SELECT: while (not $eof) {
    while (length $wbuf and my @ready = $selout->can_write(0)) {
        my $len = syswrite $fhout, $wbuf, 1024;
        $wbuf = substr $wbuf, $len if $len;
    };
    if (my @ready = $selin->can_read(0)) {
        my $len = sysread $fhin, my $tmp, 1024;
        $rbuf .= $tmp if $len;
        while ($rbuf =~ s/.*?\x02(.*?)\x03//s) {
            my $msg = Protocol::EMIUCP::Message->new_from_string($1);
            if ($msg->o_r eq 'O') {
                my $rpl = Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, o_r => 'R', ack => 1);
                $wbuf .= sprintf "\x02%s\x03", $rpl->as_string;
            };
        }
        $eof = 1 unless $len;
    };
};
