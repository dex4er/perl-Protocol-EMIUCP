package Protocol::EMIUCP::Message::Exception;

use Mouse;

extends 'Protocol::EMIUCP::Exception';

use Protocol::EMIUCP::Message::Field;

with_field [qw( trn o r ot ack nack )];

has 'emiucp_string' => (
    isa       => 'Str',
    is        => 'ro',
    predicate => 'has_emiucp_string',
);

has '+string_attributes' => (
    default   => sub { [qw( message emiucp_string error )] },
);

1;
