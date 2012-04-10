package Protocol::EMIUCP::Message::Role::OT_01;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;

has_field ot => (
    default       => '01',
    documentation => 'Call Input Operation',
);


1;
