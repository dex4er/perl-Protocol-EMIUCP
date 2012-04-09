package Protocol::EMIUCP::Message::Role::ack;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Types;

has ack => (is => 'ro', isa => 'ACK', coerce => 1, default => 'A');


1;
