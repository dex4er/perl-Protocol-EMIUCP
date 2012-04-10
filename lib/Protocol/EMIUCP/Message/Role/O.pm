package Protocol::EMIUCP::Message::Role::O;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::Role::Base';

use Protocol::EMIUCP::Field;

has_field o_r => (default => 'O');


1;
