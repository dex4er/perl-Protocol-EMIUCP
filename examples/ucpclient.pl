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

my $sock = IO::Socket::INET->new(%opts) or die "Can't connect EMI-UCP server: $!";

my $msg = Protocol::EMIUCP::Message->new(%fields);

my $cv = AE::cv;

my $conn = Protocol::EMIUCP::Connection->new(
    fh         => $sock,
    on_message => sub {
        $cv->send;
    },
);

$conn->write_message($msg);

$cv->recv;

