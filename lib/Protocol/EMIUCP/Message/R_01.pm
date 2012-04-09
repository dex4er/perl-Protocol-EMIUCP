package Protocol::EMIUCP::Message::R_01;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::R';
with 'Protocol::EMIUCP::Message::OT_01';
with 'Protocol::EMIUCP::Message::sm';


1;
