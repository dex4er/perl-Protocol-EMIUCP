package Protocol::EMIUCP::Message::Role::O;

use 5.008;

our $VERSION = '0.01';


use Moose::Role;
with 'Protocol::EMIUCP::Message::Role::Base';

use Protocol::EMIUCP::Types;

has o_r      => (is => 'ro', isa => 'O_R', default => 'O', required => 1);


1;
