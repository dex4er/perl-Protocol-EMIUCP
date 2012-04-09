package Protocol::EMIUCP::Message::Role::R;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::Role';

use Protocol::EMIUCP::Types;

has o_r      => (is => 'ro', isa => 'O_R', default => 'R', required => 1);


1;
