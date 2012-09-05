#!/usr/bin/perl

# The simplest fake SMSC
#
# Example:
#     fakesmsc-emiucp.pl localhost 5000

use strict;
use warnings;

use lib 'lib', '../lib';

use Protocol::EMIUCP::Connection;

use AnyEvent;
use AnyEvent::Socket;

use Scalar::Util qw(blessed);

die "Usage: $0 0.0.0.0 12345\n" unless @ARGV;

my %opts; @opts{qw(Host Port)} = @ARGV;

my $cv = AE::cv;

tcp_server $opts{Host}, $opts{Port}, sub {
    my ($fh) = @_;

    my $conn = Protocol::EMIUCP::Connection->new(
        fh => $fh,
    );
};

$cv->recv;
