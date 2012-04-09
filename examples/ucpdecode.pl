#!/usr/bin/perl

use lib 'lib', '../lib';

use Protocol::EMIUCP;
use Data::Dumper ();

my $str = $ARGV[0] || die "Usage: $0 ucp_string\n";

my $msg = Protocol::EMIUCP->new_message_from_string($str);

print Data::Dumper->new([ $msg->as_hashref ])->Quotekeys(0)->Sortkeys(1)->Terse(1)->Dump;
