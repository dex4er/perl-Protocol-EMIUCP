#!/usr/bin/perl

# The simplest fake SMSC server
# which uses Protocol::EMIUCP::Connection module
#
# Example:
#     fakesmsc.pl localhost 5000 O52Echo=1

use strict;
use warnings;

BEGIN { eval { require POSIX::strftime::GNU; POSIX::strftime::GNU->import } if $^O =~ /^(MSWin32|cygwin|interix)$/ }

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use AnyEvent;
use AnyEvent::Socket;
use AnyEvent::Log;

use POSIX ();
use Scalar::Util qw(blessed);

die "Usage: $0 host port field=value field=value Opt=value...\n" unless @ARGV;

$ENV{PERL_ANYEVENT_LOG} = 'filter=note' unless defined $ENV{PERL_ANYEVENT_LOG};

my ($host, $port, @args) = @ARGV;

my %opts = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { /^[A-Z]/ } @args;
my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } grep { /^[a-z]/ } @args;

my $cv = AE::cv;

AE::log info => "*** Listen on $host:$port";

my $scts = sub {
    my @t = localtime;
    $t[5] %= 100;
    return sprintf '%02d%02d%02d%02d%02d%02d', @t[3,4,5,2,1,0];
};

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
                                +(sm => $msg->oadc . ':' . $scts->());
                            }
                            else {
                                +();
                            };
                        };
                        Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, r => 1, ack => 1, %sm);
                    }
                    else {
                        # Not allowed by SMSC
                        Protocol::EMIUCP::Message->new(
                            trn => $msg->trn,
                            ot => $msg->ot,
                            r => 1,
                            nack => 1,
                            ec => EC_OPERATION_NOT_ALLOWED,
                            sm => 'emiserver does not support this operation',
                        );
                    };
                };
                $self->write_message($rpl);

                if ($msg->o and $msg->ot eq 51) {
                    if ($msg->nrq) {
                        $self->write_message(Protocol::EMIUCP::Message->new(
                            ot => 53,
                            o => 1,
                            adc => $msg->oadc,
                            oadc => $msg->adc,
                            scts => $scts->(),
                            dscts => $scts->(),
                            dst => $fields{rsn} ? 0 : 2,
                            rsn => $fields{rsn} || '000',
                            mt => 3,
                            amsg_utf8 => $fields{rsn}
                                ? sprintf("Message for %s, with identifier %s could not be delivered because of  Unknown problem (code %03d)", $fields{rsn}||0)
                                : POSIX::strftime("Message for %%s, with identifier %%s was delivered at %Y-%m-%d %H:%M:%S.", localtime),
                            %fields,
                        ));
                    };

                    if ($opts{O52}) {
                        $self->write_message(Protocol::EMIUCP::Message->new(
                            ot => 52,
                            o => 1,
                            adc => $msg->oadc,
                            oadc => $msg->adc,
                            scts => $scts->(),
                            %fields,
                        ));
                    };

                    if ($opts{O52Echo}) {
                        $self->write_message($msg->clone(
                            ot => 52,
                            adc => $msg->oadc,
                            oadc => $msg->adc,
                            scts => $scts->(),
                            %fields,
                        ));
                    };
                };
            };
        },
    );
};

$cv->recv;
