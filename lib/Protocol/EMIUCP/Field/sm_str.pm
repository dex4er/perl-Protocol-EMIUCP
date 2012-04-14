package Protocol::EMIUCP::Field::sm_str;

use 5.006;

our $VERSION = '0.01';


use Moose::Role;

use Protocol::EMIUCP::Field;

has sm => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_sm',
);


1;
