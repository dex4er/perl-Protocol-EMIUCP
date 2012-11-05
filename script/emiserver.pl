#!/usr/bin/perl

# The simplest fake SMSC server
# which uses Protocol::EMIUCP::Connection module
#
# Example:
#     fakesmsc.pl localhost 5000

use strict;
use warnings;

use if $^O =~ /^(MSWin32|cygwin|interix)$/, maybe => 'POSIX::strftime::GNU';

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use AnyEvent;
use AnyEvent::Socket;
use AnyEvent::Log;

use Scalar::Util qw(blessed);

die "Usage: $0 0.0.0.0 12345\n" unless @ARGV;

$ENV{PERL_ANYEVENT_LOG} = 'filter=note' unless defined $ENV{PERL_ANYEVENT_LOG};

my ($host, $port) = @ARGV;

my $cv = AE::cv;

AE::log info => "*** Listen on $host:$port";

tcp_server $host, $port, sub {
    my ($fh, $host, $port) = @_;

    AE::log info => "*** Connection from $host:$port";

    my $conn = Protocol::EMIUCP::Connection->new(
        fh         => $fh,
        window     => 100,
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
