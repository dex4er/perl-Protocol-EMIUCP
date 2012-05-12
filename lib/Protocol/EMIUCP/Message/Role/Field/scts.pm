package Protocol::EMIUCP::Message::Role::Field::scts;

use Moose::Role;

use Moose::Util::TypeConstraints;

subtype 'EMIUCP_SCTS' => as 'EMIUCP_Num_12';

class_type 'DateTime';

coerce  'EMIUCP_SCTS'
    => from 'DateTime'
    => via { DateTime::Format::EMIUCP::SCTS->format_datetime($_) };

use Protocol::EMIUCP::Message::Field;

has_field 'scts' => (isa => 'EMIUCP_SCTS');

use constant HAVE_DATETIME => !! eval { require DateTime::Format::EMIUCP::SCTS };

has 'scts_datetime' => (
    isa       => 'Maybe[DateTime]',
    is        => 'ro',
    predicate => 'has_scts_datetime',
    init_arg  => undef,
    HAVE_DATETIME ? (
        lazy      => 1,
        default   => sub {
            defined $_[0]->{scts} ? DateTime::Format::EMIUCP::SCTS->parse_datetime($_[0]->{scts}) : undef
        },
    ) : (),
);

1;
