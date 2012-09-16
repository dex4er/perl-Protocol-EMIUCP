#!/usr/bin/perl

# The simplest fake SMSC
#
# Example:
#     fakesmsc-emiucp.pl localhost 5000

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use AnyEvent;
use AnyEvent::Socket;

use Scalar::Util qw(blessed);

die "Usage: $0 0.0.0.0 12345\n" unless @ARGV;

my ($host, $port) = @ARGV;

my $cv = AE::cv;

tcp_server $host, $port, sub {
    my ($fh) = @_;

    my $conn = Protocol::EMIUCP::Connection->new(
        window => 100,
        fh => $fh,
        on_message => sub {
            my ($self, $msg) = @_;
            if ($msg->o) {
                my $rpl = do {
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
                $self->write_message($rpl);
            };
        },
    );
};

$cv->recv;
