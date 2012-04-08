package Protocol::EMIUCP::Message::R_01;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::R';
with 'Protocol::EMIUCP::Message::OT_01';

use Protocol::EMIUCP::Types;

has sm       => (is => 'ro');


1;
