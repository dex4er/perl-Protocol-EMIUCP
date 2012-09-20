package Protocol::EMIUCP::OO::Argument::Exception;

use Mouse;

extends 'Protocol::EMIUCP::Exception';

has 'argument' => (
    isa       => 'Str',
    is        => 'ro',
    predicate => 'has_argument',
);

has '+string_attributes' => (
    default   => sub { [qw( message argument error )] },
);

1;
