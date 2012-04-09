package Protocol::EMIUCP::Message::Role::R_01;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::Role::R';
with 'Protocol::EMIUCP::Message::Role::OT_01';

with 'Protocol::EMIUCP::Message::Role::sm';


1;
