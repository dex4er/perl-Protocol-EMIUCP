#!/usr/bin/perl

use lib 'lib', '../lib';

use Protocol::EMIUCP;
use Data::Dumper ();

die "Usage: $0 field=value field=value\n" unless @ARGV;

my %fields = map { /^(.*)=(.*)$/ and ($1, $2) } @ARGV;

my $msg = Protocol::EMIUCP->new_message(%fields);

print $msg->as_string, "\n";
