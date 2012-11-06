#!/usr/bin/perl

=head1 NAME

emiclient - simple EMI-UCP protocol client

=head1 SYNOPSIS

B<emiclient> I<host> I<port>
field=value field=value ...
Option=value Option=value ...

Examples:

  $ emiclient 127.0.0.1 12345 adc=507998000 oadc=123 mt=3 amsg_utf8=TEST

=head1 DESCRIPTION

This is a command-line EMI-UCP client which connects to given I<host> and
I<port>.

By default the O/51 message is sent.

=cut

use strict;
use warnings;

our $VERSION = '0.01';

BEGIN { eval { require POSIX::strftime::GNU; POSIX::strftime::GNU->import } }

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use IO::File;
use IO::Socket::INET;

use AnyEvent::Log;

use Scalar::Util qw(blessed);

my ($host, $port, @args) = @ARGV;

die "Usage: $0 host port field=value field=value Opt=value...\n" unless defined $host and defined $port;

my %opts = (PeerAddr => "$host:$port", map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { /^[A-Z]/ } @args);
my %fields = (o => 1, ot => 51, map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } grep { /^[a-z]/ } @args);

$AnyEvent::Log::FILTER->level(defined $opts{LogLevel} ? $opts{LogLevel} : 'note')
    unless defined $ENV{PERL_ANYEVENT_LOG};

my $sock = IO::Socket::INET->new(
    %opts,
) or die "Can't connect EMI-UCP server: $!";
$sock->blocking(0) or die "Can't set socket to non-blocking: $!'";

my $conn = Protocol::EMIUCP::Connection->new(
    fh          => $sock,
    defined $opts{Window} ? (
        window  => $opts{Window},
    ) : (),
    defined $opts{Pwd} ? (
        login => defined $opts{Login} ? $opts{Login} : $fields{oadc},
        pwd   => $opts{Pwd},
    ) : (),
    on_message => sub {
        my ($self, $msg) = @_;
        if ($msg->o) {
            # Not allowed by client
            my $rpl = $msg->new_response(
                nack => 1,
                ec => EC_OPERATION_NOT_ALLOWED,
                sm => 'emiclient does not support this operation',
            );
            $self->write_message($rpl);
        };
    },
);

$conn->login_session;

if ($opts{AdcFromFile}) {
    my $fh = IO::File->new($opts{AdcFromFile})
        or die "Can not open file `$opts{AdcFromFile}': $!";
    while (my $adc = $fh->getline) {
        chomp $adc;
        next unless $adc =~ /^\d+$/;
        my $msg = Protocol::EMIUCP::Message->new(%fields, adc => $adc);
        $conn->wait_for_any_free_out_slot;
        $conn->write_message($msg);
    };
}
else {
    my $msg = Protocol::EMIUCP::Message->new(%fields);

    for (my $i = 1; $i <= ($opts{Requests}||1); $i++) {
        $conn->wait_for_any_free_out_slot;
        $conn->write_message($msg);
    };
};

$conn->wait_for_all_free_slots;

$conn->wait($opts{Wait}) if $opts{Wait};

END {
    $conn->DISPOSE if $conn;
}

=head1 OPTIONS

=over

=item host

Remote host address

=item port

Remote port address

=item field

Any EMI-UCP field which makes a request message. By default the O/51 message
is sent (C<o=1> C<ot=51> fields are set). The C<checksum> and C<len> are
calculated automatically and can be ommited.

=item LocalAddr

Local host bind address (hostname[:port])

=item ReuseAddr

Set SO_REUSEADDR before binding

=item Proto, Type, MultiHomed, ...

See L<IO::Socket::INET> options for C<new> constructor

=item Window

Window size for O/5x operations (default: 1)

=item Login

Login for O/60 authorization (default: oadc field)

=item Pwd

Password for O/60 authorization (undefined means no authorization is required)

=item AdcFromFile

The file name for list of numbers. The message will be sent to each recipient
(adc field) from this file (one number per line).

=item Requests

Requests number for the same message

=item Wait

Waits number of seconds before exiting program.

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
