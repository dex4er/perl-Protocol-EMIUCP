#!/usr/bin/perl -d:NYTProf

use lib 'lib', '../lib';
use Protocol::EMIUCP::Message;

my $str = '00/00070/O/01/01234567890/09876543210//3/53686F7274204D657373616765/D9';

foreach (1..10000) {
    my $msg = Protocol::EMIUCP::Message->new_from_string($str);
    die $msg->as_string if $msg->as_string ne $str;
}

print "tmon.out data collected. Call nytprofhtml\n";
