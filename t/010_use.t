#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 4;

BEGIN { use_ok 'Protocol::EMIUCP' };
BEGIN { use_ok 'Protocol::EMIUCP::Connection' };
BEGIN { use_ok 'Protocol::EMIUCP::Message' };
BEGIN { use_ok 'Protocol::EMIUCP::Session' };
