package Protocol::EMIUCP::Message::O;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message';

use Protocol::EMIUCP::Types;

has o_r      => (is => 'ro', isa => 'O_R', default => 'O', required => 1);


1;
