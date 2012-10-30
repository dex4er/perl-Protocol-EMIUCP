#!/usr/bin/perl

# Decoder of EMI-UCP message
#
# Example:
#     ucpdecode.pl 00/00070/O/51/507998000/123/////////////////3//54455354/////////////19

use Protocol::EMIUCP;
use Data::Dumper ();

my $str = $ARGV[0] || die "Usage: $0 ucp_string\n";

my $msg = Protocol::EMIUCP->new_message_from_string($str);

my $dump = Data::Dumper->new([ $msg->as_hashref ])
    ->Indent(1)
    ->Pair('=')
    ->Quotekeys(0)
    ->Sortkeys(1)
    ->Useqq(1)
    ->Terse(1)
    ->Dump;
$dump =~ s/^{\n(.*)\n}$/$1/s;
$dump =~ s/^\s\s(.*?),?$/$1/mg;
print $dump;
