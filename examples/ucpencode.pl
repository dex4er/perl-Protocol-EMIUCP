#!/usr/bin/perl

use lib 'lib', '../lib';

use Protocol::EMIUCP;

die "Usage: $0 field=value field=value\n" unless @ARGV;

my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } @ARGV;

my $msg = Protocol::EMIUCP->new_message(%fields);

print $msg->as_string, "\n";
