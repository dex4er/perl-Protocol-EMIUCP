#!/usr/bin/perl

# The simplest fake SMSC
# which uses low-level IO modules
#
# Example:
#     fakesmsc-iosocket.pl localhost 5000

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP::Message;

use IO::Socket::INET;
use IO::Select;

use Scalar::Util qw(blessed);

die "Usage: $0 0.0.0.0 12345\n\tSee IO::Socket::INET for accepted options\n" unless @ARGV;

my ($host, $port, @args) = @ARGV;

$SIG{CHLD} = 'IGNORE';

my %opts = (
    Listen => 1,
    LocalAddr => "$host:$port",
    map { /^(.*?)=(.*)$/ and ($1 => $2) } @args
);

my $server = IO::Socket::INET->new(%opts) or die "$0: server: $!";

while (my $fh = $opts{Listen} ? $server->accept : $server) {
    next if fork;
    $fh->blocking(0);
    my $rbuf = my $wbuf = my $eof = '';
    my $sel = IO::Select->new($fh);
    while (not $eof) {
        while (length $wbuf and my @ready = $sel->can_write(0)) {
            my $len = syswrite $fh, $wbuf, 1024;
            $wbuf = substr $wbuf, $len if $len;
        };
        if (my @ready = $sel->can_read(0)) {
            my $len = sysread $fh, my $tmp, 1024;
            $rbuf .= $tmp if $len;
            while ($rbuf =~ s/.*?\x02(.*?)\x03//s) {
                my $str = $1;
                my $msg = eval { Protocol::EMIUCP::Message->new_from_string($str) };
                my $rpl = do {
                    if (my $e = $@) {
                        # Cannot parse EMI-UCP message
                        warn $e;
                        Protocol::EMIUCP::Message->new(trn => $e->trn, ot => $e->ot, r => 1, nack => 1, ec => EC_SYNTAX_ERROR)
                            if $e->o;
                    }
                    elsif ($msg and $msg->o) {
                        printf "%s <<< [%s]\n", scalar localtime, $msg->as_string;
                        # Reply only for Operation
                        if ($msg->ot =~ /^(01|51|60)$/) {
                            # OT allowed by SMSC
                            my %sm = do {
                                if ($msg->ot =~ /^(01|51)$/) {
                                    my @t = localtime;
                                    $t[5] %= 100;
                                    +(sm => $msg->oadc . ':' . sprintf '%02d%02d%02d%02d%02d%02d', @t[3,4,5,2,1,0]);
                                }
                                else {
                                    +();
                                };
                            };
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, r => 1, ack => 1, %sm);
                        }
                        else {
                            # Not allowed by SMSC
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, r => 1, nack => 1, ec => EC_OPERATION_NOT_ALLOWED);
                        };
                    };
                };
                if ($rpl) {
                    printf "%s >>> [%s]\n", scalar localtime, $rpl->as_string;
                    $wbuf .= sprintf "\x02%s\x03", $rpl->as_string;
                };
            };
            $eof = 1 unless $len;
        };
    };
    last;
};
