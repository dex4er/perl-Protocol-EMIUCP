#!/usr/bin/perl -d:NYTProf

use lib 'lib', '../lib';
use Protocol::EMIUCP::Message;

my $str = '39/00099/O/51/0657467/078769//1//7//1/0545765/0122/1/0808971800///////4/32/F5AA34DE////1/////////65';

foreach (1..1000) {
    my $msg = Protocol::EMIUCP::Message->new_from_string($str);
    die $msg->as_string if $msg->as_string ne $str;
}

print "nytprof.out data collected. Call nytprofhtml --open\n";
