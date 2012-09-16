#!/usr/bin/perl

# The simplest fake SMSC
#
# Example:
#     ucpclient.pl PeerAddr=127.0.0.1:12345 ot=51 adc=123 oadc=456 amsg=TEST

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP::Connection;
use Protocol::EMIUCP::Message;

use AnyEvent;
use IO::Socket::INET;

use Scalar::Util qw(blessed);

die "Usage: $0 PeerAddr=ip:port field=value field=value...\n" unless @ARGV;

my %opts = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { /^[A-Z]/ } @ARGV;
my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } grep { /^[a-z]/ } @ARGV;

my $sock = IO::Socket::INET->new(
    Blocking => 0,
    %opts,
) or die "Can't connect EMI-UCP server: $!";

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

$conn->open_session;

for (my $i = 1; $i <= ($opts{Requests}||1); $i++) {
    $conn->wait_for_any_free_slot;
    $conn->write_message($msg)
};

$conn->wait_for_all_free_slots;
