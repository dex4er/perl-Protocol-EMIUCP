#!/usr/bin/perl

=head1 NAME

emiclient - simple EMI-UCP server (SMSC emulator)

=head1 SYNOPSIS

B<emiserver> I<host> I<port>
field=value field=value ...
Option=value Option=value ...

Examples:

  $ emiserver 0.0.0.0 12345 Reply=PING mt=3 amsg_utf8=PONG

=head1 DESCRIPTION

This is a command-line EMI-UCP server which receives incoming connections and
acts like SMSC.

By default it accepts any O/51 and O/60 messages and it can be configured that
it can returns O/52 and O/53 messages.

=cut

use strict;
use warnings;

our $VERSION = '0.01';

BEGIN { eval { require POSIX::strftime::GNU; POSIX::strftime::GNU->import } }

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use AnyEvent;
use AnyEvent::Socket;
use AnyEvent::Log;

use POSIX ();
use Scalar::Util qw(blessed);

my ($host, $port, @args) = @ARGV;

die "Usage: $0 host port field=value field=value Opt=value...\n" unless defined $host and defined $port;

my %opts = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { /^[A-Z]/ } @args;
my %fields = (o => 1, ot => 52, map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } grep { /^[a-z]/ } @args);

$AnyEvent::Log::FILTER->level(defined $opts{LogLevel} ? $opts{LogLevel} : 'note')
    unless defined $ENV{PERL_ANYEVENT_LOG};

my $cv = AE::cv;

AE::log info => "*** Listen on $host:$port";

my $make_scts = sub {
    my @t = localtime;
    $t[5] %= 100;
    return sprintf '%02d%02d%02d%02d%02d%02d', @t[3,4,5,2,1,0];
};

tcp_server $host, $port, sub {
    my ($fh, $host, $port) = @_;

    AE::log info => "*** Connection from $host:$port";

    my $is_authorized;

    my $conn = Protocol::EMIUCP::Connection->new(
        fh         => $fh,
        window     => $opts{Window} || 100,
        on_message => sub {
            my ($self, $msg) = @_;

            if ($msg->o) {
                my $rpl = do {
                    # Reply only for Operation
                    if ($msg->ot eq '60' and not $is_authorized and defined $opts{Login} and defined $opts{Pwd}) {
                        # Authorization
                        if ($msg->oadc eq $opts{Login} and $msg->pwd_utf8 eq $opts{Pwd}) {
                            $is_authorized = 1;
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, r => 1, ack => 1);
                        }
                        else {
                            Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, r => 1, nack => 1, ec => EC_AUTHENTICATION_FAILURE, sm => 'authentication failure');
                        };
                    }
                    if ($msg->ot =~ /^(01|51)$/) {
                        # OT allowed by SMSC
                        Protocol::EMIUCP::Message->new(trn => $msg->trn, ot => $msg->ot, r => 1, ack => 1, sm => $msg->oadc . ':' . $make_scts->());
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
                            adc => $msg->oadc,
                            oadc => $msg->adc,
                            scts => $make_scts->(),
                            dscts => $make_scts->(),
                            dst => $fields{Rsn} ? 0 : 2,
                            rsn => $fields{Rsn} || '000',
                            mt => 3,
                            amsg_utf8 => $fields{Rsn}
                                ? sprintf("Message for %s, with identifier %s could not be delivered because of  Unknown problem (code %03d)", $fields{rsn}||0)
                                : POSIX::strftime("Message for %%s, with identifier %%s was delivered at %Y-%m-%d %H:%M:%S.", localtime),
                            %fields,
                            ot => 53,
                            o => 1,
                        ));
                    };

                    if ($opts{Reply} and $msg->amsg_utf8 =~ /$opts{Reply}/) {
                        $self->write_message(Protocol::EMIUCP::Message->new(
                            adc => $msg->oadc,
                            oadc => $msg->adc,
                            scts => $make_scts->(),
                            %fields,
                        ));
                    };
                };
            };
        },
    );
};

$cv->recv;

=head1 OPTIONS

=over

=item host

Local host bind address. C<0.0.0.0> means that it listens on all intrafaces.

=item port

Local host bind port

=item fields

Any EMI-UCP field which makes a reply message. By default the O/51 message is
sent (C<o=1> C<ot=51> fields are set). The C<checksum> and C<len> are
calculated automatically and can be ommited. See C<Reply> option for more
details.

=item Window

Window size for O/5x operations (default: 100)

=item Login

Login for O/60 authorization. If not set, all O/60 requests are accepted.

=item Pwd

Password for O/60 authorization. If not set, all O/60 requests are accepted.

=item Reply

Regexp for incoming message (C<amsg> field) which triggers O/52 reply message.
Reply message is combined from fields parameters.

=item Rsn

Value for C<rsn> field for O/53 message. This message is replied if C<nrq>
field is set in incoming O/51 message.

=item LogLevel

Log level: fatal, alert, critical, error, warn, note, info, debug, trace
(default: note). Ignored if C<PERL_ANYEVENT_LOG> environment variable is
already set. See L<AnyEvent::Log> for details.

=back

=head1 SEE ALSO

L<emiserver>, L<emiencode>, L<emidecode>, L<emisplit>,
L<http://github.com/dex4er/perl-Protocol-EMIUCP>.

=head1 BUGS

This tool has unstable features and can change in future.

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
