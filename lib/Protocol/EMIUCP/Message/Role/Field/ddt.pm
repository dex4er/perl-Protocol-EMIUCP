package Protocol::EMIUCP::Message::Role::Field::ddt;

use Moose::Role;

use Moose::Util::TypeConstraints;

subtype 'EMIUCP_DDT' => as 'EMIUCP_Num_10';

class_type 'DateTime';

coerce  'EMIUCP_DDT'
    => from 'DateTime'
    => via { DateTime::Format::EMIUCP::DDT->format_datetime($_) };

use Protocol::EMIUCP::Message::Field;

has_field 'ddt' => (isa => 'EMIUCP_Num_10');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::DDT };

has 'ddt_datetime' => (
    isa       => 'Maybe[DateTime]',
    is        => 'ro',
    predicate => 'has_ddt_datetime',
    init_arg  => undef,
    HAVE_DATETIME ? (
        lazy      => 1,
        default   => sub {
            defined $_[0]->{ddt} ? DateTime::Format::EMIUCP::DDT->parse_datetime($_[0]->{ddt}) : undef
        },
    ) : (),
);

1;
