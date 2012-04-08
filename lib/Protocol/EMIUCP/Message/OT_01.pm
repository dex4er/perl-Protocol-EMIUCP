package Protocol::EMIUCP::Message::OT_01;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;

has ot       => (is => 'ro', isa => 'Int2', default => '01', required => 1, coerce => 1);


1;
