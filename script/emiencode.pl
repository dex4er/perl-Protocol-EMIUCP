#!/usr/bin/perl

# Encoder of EMI-UCP message
#
# Example:
#     ucpencode.pl o=1 ot=51 adc=507998000 oadc=123 mt=3 amsg_utf8="TEST"

use Protocol::EMIUCP;

die "Usage: $0 field=value field=value\n" unless @ARGV;

my %fields = map { /^(.*?)=(.*)$/ and ($1 => $2) } grep { not /^[^=]*_description=/ } @ARGV;

my $msg = Protocol::EMIUCP->new_message(%fields);

print $msg->as_string, "\n";
