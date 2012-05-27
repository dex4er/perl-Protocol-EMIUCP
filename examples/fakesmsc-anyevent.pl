#!/usr/bin/perl

# The simplest fake SMSC
#
# Example:
#     fakesmsc-anyevent.pl localhost 5000

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP::Message;

use AnyEvent;
use AnyEvent::Handle;
use AnyEvent::Socket;

use Scalar::Util qw(blessed);

die "Usage: $0 0.0.0.0 12345\n" unless @ARGV;

my %opts; @opts{qw(Host Port)} = @ARGV;

my $cv = AE::cv;

tcp_server $opts{Host}, $opts{Port}, sub {
    my ($fh) = @_;

    my $hdl; $hdl = AnyEvent::Handle->new(
        fh => $fh,
        on_error => sub {
            my ($hdl, $fatal, $msg) = @_;
            AE::log error => $msg;
            $hdl->destroy;
        },
        on_read => sub {
            $hdl->push_read(regex => qr/ .*? \x02 (.*?) \x03 /xs, sub {
                my ($hdl, $data) = @_;

                my $str = $1;
                my $msg = eval { Protocol::EMIUCP::Message->new_from_string($str) };
                my $rpl = do {
                    if (my $e = $@) {
                        # Cannot parse EMI-UCP message
                        AE::log error => $e;
                        Protocol::EMIUCP::Message->new(trn => $e->trn, ot => $e->ot, o_r => 'R', nack => 1, ec => EC_SYNTAX_ERROR)
                            if (($e->o_r||'') eq 'O');
                    }
                    elsif ($msg and $msg->o_r eq 'O') {
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
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, o_r => 'R', ack => 1, %sm);
                        }
                        else {
                            # Not allowed by SMSC
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, o_r => 'R', nack => 1, ec => EC_OPERATION_NOT_ALLOWED);
                        };
                    };
                };
                $hdl->push_write(sprintf "\x02%s\x03", $rpl->as_string) if $rpl;
            });
        },
        on_eof => sub {
            $hdl->destroy;
        },
    );
};

$cv->recv;
