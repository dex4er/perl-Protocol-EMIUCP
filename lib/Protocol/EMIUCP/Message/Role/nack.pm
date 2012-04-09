package Protocol::EMIUCP::Message::Role::nack;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;

has nack => (is => 'ro', isa => 'NACK', coerce => 1, default => 'N');


1;
