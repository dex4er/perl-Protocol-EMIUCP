package Protocol::EMIUCP::Message::Role::R;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::Role::Base';

use Protocol::EMIUCP::Field;

has_field o_r => (isa => 'EMIUCP_R', default => 'R');


1;
