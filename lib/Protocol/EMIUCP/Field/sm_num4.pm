package Protocol::EMIUCP::Field::sm_num4;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;

has sm => (
    is        => 'ro',
    isa       => 'EMIUCP_Num04',
    coerce    => 1,
    predicate => 'has_sm',
);


1;
