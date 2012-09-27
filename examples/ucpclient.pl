#!/usr/bin/perl

# The simplest fake SMSC
#
# Example:
#     ucpclient.pl 127.0.0.1 12345 ot=51 adc=123 oadc=456 amsg=TEST

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use AnyEvent;
use IO::Socket::INET;

use Scalar::Util qw(blessed);

die "Usage: $0 host port field=value field=value...\n" unless @ARGV;

my ($host, $port, @args) = @ARGV;

my %opts = (PeerAddr => "$host:$port", map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { /^[A-Z]/ } @args);
my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } grep { /^[a-z]/ } @args;

my $sock = IO::Socket::INET->new(
    %opts,
) or die "Can't connect EMI-UCP server: $!";
$sock->blocking(0) or die "Can't set socket to non-blocking: $!'";

my $msg = Protocol::EMIUCP::Message->new(%fields);

my $conn = Protocol::EMIUCP::Connection->new(
    fh          => $sock,
    defined $opts{Window} ? (
        window  => $opts{Window},
    ) : (),
    defined $opts{Pwd} ? (
        login   => defined $opts{Login} ? $opts{Login} : $fields{oadc},
        pwd     => $opts{Pwd},
    ) : (),
);

$conn->login_session;

for (my $i = 1; $i <= ($opts{Requests}||1); $i++) {
    $conn->wait_for_any_free_out_slot;
    $conn->write_message($msg);
};

$conn->wait_for_all_free_slots;

$conn->wait($opts{Wait}) if $opts{Wait};

$conn->close_session;
